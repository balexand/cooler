defmodule Cooler.CoolerControl do
  def start_link do
    Agent.start_link fn ->
      Gpio.write(:pump_relay, 1)
      Gpio.write(:motor_relay, 1)

      :off
    end, name: :cooler_control
  end

  def get_state do
    Agent.get(:cooler_control, &(&1))
  end

  def toggle do
    Agent.update :cooler_control, fn state ->
      case state do
        :on -> do_turn_off()
        :off -> do_turn_on()
      end
    end
  end

  defp do_turn_on do
    Gpio.write(:pump_relay, 0)

    parent = self()

    spawn_link fn ->
      # give the pad time to get wet then start the motor
      :timer.sleep(30_000)

      Agent.get parent, fn state ->
        if state == :on, do: Gpio.write(:motor_relay, 0)
      end
    end

    :on
  end

  defp do_turn_off do
    Gpio.write(:pump_relay, 1)
    Gpio.write(:motor_relay, 1)

    :off
  end
end
