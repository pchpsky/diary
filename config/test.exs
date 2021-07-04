use Mix.Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :diary, Diary.Repo,
  username: "postgres",
  password: "admin",
  database: "diary_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  template: "template0",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :diary, DiaryWeb.Endpoint,
  http: [port: 4002],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn

config :diary, :sql_sandbox, true

config :wallaby,
  otp_app: :diary,
  screenshot_on_failure: System.get_env("WALLABY_SCREENSHOT_ON_FAILURE")
