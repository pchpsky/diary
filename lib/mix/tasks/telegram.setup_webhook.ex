defmodule Mix.Tasks.Telegram.SetupWebhook do
  use Mix.Task

  @requirements ["app.config"]

  @shortdoc "Setup webhook for Telegram bot"

  @impl Mix.Task
  def run(args) do
    Application.ensure_all_started(:diary)

    token = System.get_env("TELEGRAM_BOT_TOKEN")
    host = (Enum.at(args, 0) || "https://#{System.get_env("PHX_HOST")}") |> String.replace("\"", "")

    url = "#{host}/api/telegram/#{token}"

    Mix.shell().info("Setup webhook at #{url}")

    Telegram.Api.request(token, "deleteWebhook")

    Telegram.Api.request(token, "setWebhook", url: url)
  end
end
