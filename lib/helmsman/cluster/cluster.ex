defmodule Helmsman.Cluster do
  @moduledoc """
  Encapsulates Kafka cluster data and its collection
  """

  defstruct name: nil, configured_brokers: [], advertised_brokers: []

  @type t :: %__MODULE__{}

  alias Helmsman.Cluster

  def list do
    cluster_configs = Application.get_env(:helmsman, :kafka_clusters)
    Enum.map(cluster_configs, &from_config/1)
  end

  def determine_advertised_brokers(configured_brokers) do
    KafkaEx.create_worker(
      :helmsman_probe,
      [uris: configured_brokers, consumer_group: :no_consumer_group]
    )
    metadata = KafkaEx.metadata(worker_name: :helmsman_probe)
    Enum.map(metadata.brokers, fn(broker) -> {broker.host, broker.port} end)
  end

  def from_config([name: name, brokers: brokers]) do
    %Cluster{
      name: name,
      configured_brokers: brokers,
      advertised_brokers: determine_advertised_brokers(brokers)
    }
  end
end
