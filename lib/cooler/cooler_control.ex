defmodule Cooler.CoolerControl do
  def start_link do
    Agent.start_link fn ->
      Gpio.write(:pump_relay, 1)
      :off
    end, name: :cooler_control
  end

  def get_state do
    Agent.get(:cooler_control, &(&1))
  end

  def toggle do
    Agent.update :cooler_control, fn state ->
      case state do
        :on ->
          Gpio.write(:pump_relay, 1)
          :off
        :off ->
          Gpio.write(:pump_relay, 0)
          :on
      end
    end
  end
end
