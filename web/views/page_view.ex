defmodule Cooler.PageView do
  use Cooler.Web, :view

  def submit_text(:on), do: "Turn Off"
  def submit_text(:off), do: "Turn On"
end
