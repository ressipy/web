# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ressipy,
  ecto_repos: [Ressipy.Repo]

# Configures the endpoint
config :ressipy, RessipyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c49jNq1eMqLEXvEkUlkZ4yHUUX0X+q0gGjoBnKF+HOYE0mMtf0Wd+eQGikpJoa/z",
  render_errors: [view: RessipyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ressipy.PubSub,
  live_view: [signing_salt: "NOp+1a2d"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id, :user_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix,
  format_encoders: [json: Casex.CamelCaseEncoder],
  json_library: Jason

# Use Bamboo's local adapter for viewing sent emails in development
config :ressipy, RessipyMailer, adapter: Bamboo.LocalAdapter

config :hammer,
  backend: {Hammer.Backend.ETS, [expiry_ms: 60_000 * 60 * 4, cleanup_interval_ms: 60_000 * 10]}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
