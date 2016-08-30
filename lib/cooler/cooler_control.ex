defmodule Cooler.CoolerControl do
  def start_link do
    Agent.start_link fn -> :off end, name: :cooler_control
  end

  def get_state do
    Agent.get(:cooler_control, &(&1))
  end

  def toggle do
    Agent.update :cooler_control, fn state ->
      case state do
        :on ->
          :off
        :off ->
          :on
      end
    end
  end
end
