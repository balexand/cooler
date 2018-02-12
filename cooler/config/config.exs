# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :cooler, CoolerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "acLK7lZiSE+3avzN6+gd8LMNejK/eREiVqkwB01s12MRYFMQh8HLDxfboTPhDF3e",
  render_errors: [view: CoolerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Cooler.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
