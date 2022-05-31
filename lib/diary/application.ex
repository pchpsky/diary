defmodule Diary.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Diary.Repo,
      # Start the Telemetry supervisor
      DiaryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Diary.PubSub},
      # Start the Endpoint (http/https)
      DiaryWeb.Endpoint,
      # Start a worker by calling: Diary.Worker.start_link(arg)
      # {Diary.Worker, arg}
      Diary.Telegram.Supervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Diary.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DiaryWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
