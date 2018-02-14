defmodule Cooler.PowerControllerTest do
  use ExUnit.Case

  # FIXME quick test drive
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
