defmodule Helmsman.Cluster do
  defstruct name: nil, configured_brokers: [], advertised_brokers: []

  @type t :: %__MODULE__{}

  alias Helmsman.Cluster

  def list do
    cluster_configs = Application.get_env(:helmsman, :kafka_clusters)
    Enum.map(cluster_configs, &from_config/1)
  end

  def determine_advertised_brokers(configured_brokers) do
    KafkaEx.create_worker(:worker_foo, [uris: configured_brokers, consumer_group: "meh"])
    KafkaEx.metadata(worker_name: :worker_foo).brokers
    |> Enum.map(fn(broker) -> {broker.host, broker.port} end)
  end

  def from_config([name: name, brokers: brokers]) do
    %Cluster{name: name, configured_brokers: brokers, advertised_brokers: determine_advertised_brokers(brokers)}
  end
end
