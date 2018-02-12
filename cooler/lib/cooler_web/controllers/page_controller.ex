defmodule CoolerWeb.PageController do
  use CoolerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
