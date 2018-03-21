defmodule HelmsmanWeb.ClusterView do
  use HelmsmanWeb, :view

  def connection_strings(brokers) do
    brokers
    |> Enum.map(fn({host, port}) -> "#{host}:#{port}" end)
    |> Enum.join(",")
  end
end
