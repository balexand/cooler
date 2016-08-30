defmodule Cooler.PageController do
  use Cooler.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:status, Cooler.CoolerControl.get_state)
    |> render("index.html")
  end
end
