# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :helmsman,
  ecto_repos: [Helmsman.Repo],
  kafka_clusters: [
    [
      name: "Test cluster",
      brokers: [
        {"localhost", 9092},
        {"localhost", 9093},
        {"localhost", 9094}
      ]
    ]
  ]

# Configures the endpoint
config :helmsman, HelmsmanWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UhwU/7Xv2jPGkhnrG/iOxbIqFAHrWjKn4YkYS1Qwo2Lsm6XD8pu5qHjkMohrJ+s3",
  render_errors: [view: HelmsmanWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Helmsman.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :kafka_ex,
  disable_default_worker: true,
  use_ssl: false,
  ssl_options: []

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
