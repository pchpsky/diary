import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/diary start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.
if System.get_env("PHX_SERVER") do
  config :diary, DiaryWeb.Endpoint, server: true
end

if config_env() == :prod do
  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :diary, Diary.Repo,
    ssl: false,
    socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "3"),
    # Memory optimization for database connections
    queue_target: 5000,
    queue_interval: 10_000

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :diary, DiaryWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base

  # Erlang VM memory optimization for production
  config :kernel,
    # Reduce the number of ports to save memory
    inet_dist_listen_min: 9100,
    inet_dist_listen_max: 9105

  # Configure the application for memory efficiency
  config :diary,
    # Enable garbage collection optimization
    gc_interval: 10_000,
    # Reduce memory usage for processes
    max_restarts: 2,
    max_seconds: 3

  # Aggressive memory optimization for 256MB machine
  config :logger,
    level: :warning,
    compile_time_purge_matching: [
      [level_lower_than: :warning]
    ]

  # Disable telemetry to save memory
  config :telemetry_poller, :default,
    period: 60_000,
    measurements: []

  # Optimize Phoenix for low memory
  config :phoenix,
    :json_library, Jason

  # Reduce LiveView memory usage
  config :phoenix_live_view,
    signing_salt: secret_key_base

  telegram_bot_token =
    System.get_env("TELEGRAM_BOT_TOKEN") ||
      raise """
      environment variable TELEGRAM_BOT_TOKEN is missing.
      """

  telegram_bot_uname =
    System.get_env("TELEGRAM_BOT_UNAME") ||
      raise """
      environment variable TELEGRAM_BOT_UNAME is missing.
      """

  config :diary, Diary.Telegram,
    token: telegram_bot_token,
    uname: telegram_bot_uname
end
