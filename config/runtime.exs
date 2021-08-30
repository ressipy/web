import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  IO.puts("checking runtime")

  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :ressipy, Ressipy.Repo,
    # ssl: true,
    socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("HOST", "ressipy.com")

  config :ressipy, RessipyWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    server: true,
    url: [host: host, port: 443, scheme: "https"],
    secret_key_base: secret_key_base

  sendgrid_api_key =
    System.get_env("SENDGRID_API_KEY") ||
      raise """
      environment variable SENDGRID_API_KEY is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :ressipy, RessipyMailer,
    adapter: Swoosh.Adapters.Sendgrid,
    api_key: sendgrid_api_key

  redis_url =
    System.get_env("FLY_REDIS_CACHE_URL") ||
      raise """
      environment variable FLY_REDIS_CACHE_URL is missing.
      For example: redis://USER:PASS@HOST:PORT
      """

  hammer_redis_opts = [expiry_ms: 60_000 * 60 * 2, redis_url: redis_url]
  config :hammer, backend: {Hammer.Backend.Redis, hammer_redis_opts}
end
