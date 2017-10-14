defmodule HelmsmanWeb.PageController do
  use HelmsmanWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
