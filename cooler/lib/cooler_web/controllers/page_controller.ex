defmodule CoolerWeb.PageController do
  use CoolerWeb, :controller

  def index(conn, _params) do
    mode = Cooler.PowerController.mode

    render conn, "index.html", mode: mode
  end
end
