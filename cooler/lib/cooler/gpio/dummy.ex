defmodule Cooler.GPIO.Dummy do
  @moduledoc """
  Dummy implementation of `ElixirALE.GPIO` for dev/test.
  """

  use Agent

  def start_link(pin, pin_direction, opts \\ []) do
    Agent.start_link(fn ->
      %{pin: pin, pin_direction: pin_direction, value: :not_set}
    end, opts)
  end

  def get_value(pid) do
    Agent.get(pid, &(&1.value))
  end

  def write(pid, value) do
    Agent.update(pid, &(%{&1 | value: value}))
  end
end
