# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :messengyr,
  ecto_repos: [Messengyr.Repo]

# Configures the endpoint
config :messengyr, Messengyr.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "PieAVxgCiy7GoXAv6MPDn/L2yHBGaw+mX7ppixvgne7hxkQ7ssR73CfpksDtAUpl",
  render_errors: [view: Messengyr.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Messengyr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures the Guardian library
config :guardian, Guardian,
  issuer: "Messengyr",
  ttl: { 30, :days },
  allowed_drift: 2000,
  secret_key: "5ecret_k3y",
  serializer: Messengyr.Accounts.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
