use Mix.Config
config :messengyr, Messengyr.Web.Endpoint,
  http: [port: {:system, "PORT"}],
  root: ".",
  server: true,
  # Make sure your change the URL to your app's URL:
  url: [scheme: "https", host: "logit-messengyr.herokuapp.com", port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

config :messengyr, Messengyr.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20,
  ssl: true

config :guardian, Guardian,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

config :phoenix, :serve_endpoints, true
