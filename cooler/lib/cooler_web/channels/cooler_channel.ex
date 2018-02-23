defmodule CoolerWeb.CoolerChannel do
  use CoolerWeb, :channel
  intercept ["state"]

  def join("cooler", _payload, socket) do
    send self(), :send_initial_state

    {:ok, socket}
  end

  def handle_info(:send_initial_state, socket) do
    mode = Cooler.PowerController.mode
    push_state(%{mode: mode}, socket)

    {:noreply, socket}
  end

  def handle_in("toggle", %{}, socket) do
    Cooler.PowerController.toggle

    {:noreply, socket}
  end

  def handle_out("state", payload, socket) do
    push_state(payload, socket)

    {:noreply, socket}
  end

  defp push_state(%{mode: mode}, socket) do
    html = Phoenix.View.render_to_string(CoolerWeb.CoolerView, "show.html", mode: mode)
    push(socket, "state", %{html: html, mode: mode})
  end
end
