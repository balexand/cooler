defmodule Cooler.CoolerController do
  use Cooler.Web, :controller

  def toggle(conn, _params) do
    Cooler.CoolerControl.toggle

    redirect conn, to: page_path(conn, :index)
  end
end
