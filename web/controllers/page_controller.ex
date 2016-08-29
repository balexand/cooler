defmodule Cooler.PageController do
  use Cooler.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
