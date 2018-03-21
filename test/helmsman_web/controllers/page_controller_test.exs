defmodule HelmsmanWeb.ClusterControllerTest do
  use HelmsmanWeb.ConnCase

  alias Helmsman.Cluster

  describe "GET /" do
    test "basic page render", %{conn: conn} do
      conn = get conn, "/"
      assert html_response(conn, 200) =~ "Helmsman"
    end

    test "lists clusters and brokers", %{conn: conn} do
      clusters = Cluster.list

      conn = get conn, "/"
      response = html_response(conn, 200)

      for cluster <- clusters do
        assert response =~ cluster.name
        for {broker_host, broker_port} <- cluster.configured_brokers do
          assert response =~ "#{broker_host}:#{broker_port}"
        end
        for {broker_host, broker_port} <- cluster.advertised_brokers do
          assert response =~ "#{broker_host}:#{broker_port}"
        end
      end
    end
  end
end
