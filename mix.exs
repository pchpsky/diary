defmodule Diary.MixProject do
  use Mix.Project

  def project do
    [
      app: :diary,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Diary.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:bcrypt_elixir, "~> 3.0"},
      {:phoenix, "~> 1.7", override: true},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.9"},
      {:ecto_enum, "~> 1.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.18"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phx_gen_auth, "~> 0.6", only: [:dev], runtime: false},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.22"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:guardian, "~> 2.3"},
      {:absinthe, "~> 1.7"},
      {:absinthe_plug, "~> 1.5.8"},
      {:timex, "~> 3.7"},
      {:heroicons, "~> 0.5"},
      {:telegram, git: "https://github.com/visciang/telegram.git", tag: "0.22.4"},
      {:wallaby, "~> 0.30", runtime: false, only: :test},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.1", only: [:dev, :test], runtime: false},
      {:esbuild, "~> 0.6", runtime: Mix.env() == :dev}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "assets.compile --quiet",
        "ecto.create --quiet",
        "ecto.migrate --quiet",
        "test"
      ],
      "assets.compile": &compile_assets/1,
      "assets.deploy": [
        "esbuild default --minify",
        "cmd --cd assets npm run deploy",
        "phx.digest"
      ]
    ]
  end

  defp compile_assets(_) do
    Mix.shell().cmd(
      "cd assets && ./node_modules/.bin/webpack --mode development",
      quiet: true
    )
  end
end
