defmodule Cooler.PowerControllerTest do
  alias Cooler.PowerController

  @gpio Application.get_env(:cooler, :gpio)
  @motor :motor_relay
  @pump :pump_relay
  @on 0
  @off 1

  use ExUnit.Case

  test "integration test with side effects" do
    assert PowerController.mode == :off
    assert @gpio.get_value(@motor) == @off
    assert @gpio.get_value(@pump) == @off

    :ok = PowerController.toggle
    assert PowerController.mode == :wetting
    assert @gpio.get_value(@motor) == @off
    assert @gpio.get_value(@pump) == @on

    :ok = PowerController.toggle
    assert PowerController.mode == :off
    assert @gpio.get_value(@motor) == @off
    assert @gpio.get_value(@pump) == @off

    :ok = PowerController.toggle
    assert PowerController.mode == :wetting
    assert @gpio.get_value(@motor) == @off
    assert @gpio.get_value(@pump) == @on

    send PowerController, :wetting_complete
    assert PowerController.mode == :on
    assert @gpio.get_value(@motor) == @on
    assert @gpio.get_value(@pump) == @on
  end
end

defmodule Cooler.PowerController.StateTest do
  use ExUnit.Case, async: true
  alias Cooler.PowerController.State

  test "put_timer_ref/2" do
    ref = make_ref()
    assert State.put_timer_ref(%State{}, ref) == %State{wetting_timer_ref: ref}
  end

  test "toggle/1 when :off" do
    assert State.toggle(%State{mode: :off}) == %State{mode: :wetting}
  end

  test "toggle/1 when :wetting" do
    assert State.toggle(%State{mode: :wetting}) == %State{mode: :off}
  end

  test "toggle/1 when :on" do
    assert State.toggle(%State{mode: :on}) == %State{mode: :off}
  end

  test "wetting_complete/1 when :wetting" do
    assert State.wetting_complete(%State{mode: :wetting, wetting_timer_ref: make_ref()}) ==
      %State{mode: :on, wetting_timer_ref: nil}
  end

  test "wetting_complete/1 when :off" do
    assert State.wetting_complete(%State{mode: :off}) == %State{mode: :off}
  end

  test "wetting_complete/1 when :on" do
    assert State.wetting_complete(%State{mode: :on}) == %State{mode: :on}
  end
end
