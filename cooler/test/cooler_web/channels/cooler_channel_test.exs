defmodule CoolerWeb.CoolerChannelTest do
  use CoolerWeb.ChannelCase

  alias CoolerWeb.CoolerChannel

  setup do
    {:ok, _, socket} =
      socket()
      |> subscribe_and_join(CoolerChannel, "cooler")

    {:ok, socket: socket}
  end

  test "sends initial state" do
    assert_push "state", %{mode: _, html: _}
  end

  test "broadcasts state", %{socket: socket} do
    assert_push "state", %{mode: _, html: _}

    broadcast_from! socket, "state", %{mode: :off}
    assert_push "state", %{mode: :off, html: _}
  end
end
