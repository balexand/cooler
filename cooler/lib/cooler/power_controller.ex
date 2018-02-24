defmodule Cooler.PowerController do
  defmodule State do
    @moduledoc false

    defstruct mode: :off, wetting_timer_ref: nil

    def put_timer_ref(%__MODULE__{} = s, ref) do
      %{s | wetting_timer_ref: ref}
    end

    def toggle(%__MODULE__{mode: :off} = s) do
      %{s | mode: :wetting}
    end

    def toggle(%__MODULE__{mode: m} = s) when m in [:wetting, :on] do
      %{s | mode: :off}
    end

    def wetting_complete(%__MODULE__{mode: :wetting} = s), do: %{s | mode: :on, wetting_timer_ref: nil}
    def wetting_complete(%__MODULE__{} = s), do: s
  end

  use GenServer

  @wetting_delay 30_000
  @gpio Application.get_env(:cooler, :gpio)
  @motor :motor_relay
  @pump :pump_relay
  @on 0
  @off 1

  ###
  # Client API
  ###

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, Keyword.put_new(opts, :name, __MODULE__))
  end

  def mode do
    GenServer.call(__MODULE__, :mode)
  end

  def toggle do
    GenServer.call(__MODULE__, :toggle)
  end

  ###
  # Server API
  ###

  def init(nil) do
    @gpio.write(@motor, @off)
    @gpio.write(@pump,  @off)

    {:ok, %State{}}
  end

  def handle_call(:mode, _from, %State{mode: mode} = state) do
    {:reply, mode, state}
  end

  def handle_call(:toggle, _from, state) do
    state = state
    |> cancel_timer
    |> State.toggle
    |> set_wetting_timer

    broadcast_state(state)
    set_motor(state)
    set_pump(state)

    {:reply, :ok, state}
  end

  def handle_info(:wetting_complete, state) do
    state = State.wetting_complete(state)

    broadcast_state(state)
    set_motor(state)
    set_pump(state)

    {:noreply, state}
  end

  defp broadcast_state(%State{mode: mode}) do
    # NOTE hardcoded dependency from Cooler to CoolerWeb not ideal
    CoolerWeb.Endpoint.broadcast!("cooler", "state", %{mode: mode})
  end

  defp cancel_timer(%State{wetting_timer_ref: ref} = s) when is_reference(ref) do
    Process.cancel_timer(ref)
    State.put_timer_ref(s, nil)
  end

  defp cancel_timer(%State{wetting_timer_ref: nil} = s), do: s

  defp set_wetting_timer(%State{mode: :wetting} = s) do
    ref = Process.send_after(self(), :wetting_complete, @wetting_delay)
    State.put_timer_ref(s, ref)
  end

  defp set_wetting_timer(%State{} = s), do: s

  defp set_motor(%State{mode: :on}), do: @gpio.write(@motor, @on)
  defp set_motor(%State{}),          do: @gpio.write(@motor, @off)
  defp set_pump(%State{mode: :off}), do: @gpio.write(@pump,  @off)
  defp set_pump(%State{}),           do: @gpio.write(@pump,  @on)
end
