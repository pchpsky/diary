# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :diary,
  ecto_repos: [Diary.Repo]

# Configures the endpoint
config :diary, DiaryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "dqqJIM+uWb58np2rqD2M68kMaCKsuqYo7MVRuTvRevkWR7KYHaQGHybVVJviN3kL",
  render_errors: [
    formats: [html: DiaryWeb.ErrorHTML, json: DiaryWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Diary.PubSub,
  live_view: [signing_salt: "Re9kaLmK"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :diary, Diary.Guardian,
  issuer: "diary",
  secret_key: "xJwSvsML7yJu/4OnXa3Ay7867ZrDL3g8HMQJU+bH9svsew5YAo5ABG11y9bb+Hzk",
  ttl: {3, :days}

config :esbuild,
  version: "0.12.18",
  default: [
    args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind, version: "3.3.3"
