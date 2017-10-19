defmodule HelmsmanWeb.PageController do
  use HelmsmanWeb, :controller

  def index(conn, _params) do
    clusters = Helmsman.Cluster.list
    render conn, "index.html", clusters: clusters
  end
end
