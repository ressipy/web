import Config

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :ressipy, Ressipy.Repo,
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
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000"),
      transport_options: [socket_opts: [:inet6]]
    ],
    secret_key_base: secret_key_base,
    server: true,
    url: [host: host, port: 443, scheme: "https"]

  sendgrid_api_key =
    System.get_env("SENDGRID_API_KEY") ||
      raise """
      environment variable SENDGRID_API_KEY is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :ressipy, RessipyMailer,
    adapter: Swoosh.Adapters.Sendgrid,
    api_key: sendgrid_api_key

  redis_url = System.get_env("FLY_REDIS_CACHE_URL")
  hammer_redis_opts = [expiry_ms: 60_000 * 60 * 2, redis_url: redis_url]
  config :hammer, backend: {Hammer.Backend.Redis, hammer_redis_opts}
end
