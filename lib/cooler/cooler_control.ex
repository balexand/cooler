defmodule Cooler.CoolerControl do
  @name __MODULE__
  @pad_wetting_timeout 30_000

  def start_link do
    GenServer.start_link __MODULE__, :off, name: @name
  end

  def get_state do
    GenServer.call @name, :get_state
  end

  def toggle do
    GenServer.call @name, :toggle
  end

  def init(:off) do
    Gpio.write(:pump_relay, 1)
    Gpio.write(:motor_relay, 1)

    {:ok, %{on_or_off: :off, timer: nil}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state.on_or_off, state}
  end

  def handle_call(:toggle, _from, %{on_or_off: :off, timer: _}) do
    Gpio.write(:pump_relay, 0)

    timer = Process.send_after self, :start_motor, @pad_wetting_timeout

    {:reply, :on, %{on_or_off: :on, timer: timer}}
  end

  def handle_call(:toggle, _from, %{on_or_off: :on, timer: timer}) do
    if timer, do: Process.cancel_timer(timer)

    Gpio.write(:pump_relay, 1)
    Gpio.write(:motor_relay, 1)

    {:reply, :off, %{on_or_off: :off, timer: nil}}
  end

  def handle_info(:start_motor, state) do
    Gpio.write(:motor_relay, 0)

    {:noreply, %{state | timer: nil}}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end
end
