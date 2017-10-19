defmodule Helmsman.Cluster do
  defstruct name: nil, configured_brokers: []

  @type t :: %__MODULE__{}

  alias Helmsman.Cluster

  def list do
    cluster_configs = Application.get_env(:helmsman, :kafka_clusters)
    Enum.map(cluster_configs, &from_config/1)
  end

  def from_config([name: name, brokers: brokers]) do
    %Cluster{name: name, configured_brokers: brokers}
  end
end
