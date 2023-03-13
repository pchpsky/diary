defmodule Diary.Telegram do
  require Logger

  import Ecto.Query

  alias Diary.Repo
  alias Diary.Telegram.UserConnection

  def make_start_url(user_id) do
    bot_uname = Application.fetch_env!(:diary, __MODULE__)[:uname]
    token = Diary.Telegram.UserTokenLookup.issue_token(user_id)

    "https://t.me/#{bot_uname}?start=#{token}"
  end

  def lookup_token(token) do
    Diary.Telegram.UserTokenLookup.pop_token(token)
  end

  def connect(user_id, chat_id) do
    Logger.info("Connecting user #{user_id} in chat #{chat_id}")

    find_or_create_connection(user_id, chat_id)
    |> Result.map_error(fn
      %{errors: [user_id: _]} ->
        :already_connected

      e ->
        Logger.error("Failed to connect user #{user_id} in chat #{chat_id}. #{inspect(e)}")
        :unknown_error
    end)
  end

  def disconnect(user_id) do
    UserConnection
    |> where(user_id: ^user_id)
    |> Repo.delete_all()
  end

  def get_user_connection(user_id) do
    UserConnection
    |> where(user_id: ^user_id)
    |> Repo.one()
  end

  def send_message(chat_id, message) do
    Logger.info("Sending message to chat #{chat_id}")

    request("sendMessage",
      chat_id: chat_id,
      text: message,
      parse_mode: "Markdown"
    )
  end

  defp request(method, request) do
    token = Application.fetch_env!(:diary, __MODULE__)[:token]
    {:ok, _} = Telegram.Api.request(token, method, request)
  end

  defp find_or_create_connection(user_id, chat_id) do
    connection =
      UserConnection
      |> where(user_id: ^user_id, chat_id: ^chat_id)
      |> Repo.one()

    connection
    |> Result.from_optional()
    |> Result.handle_error(fn _ ->
      %UserConnection{}
      |> UserConnection.changeset(%{user_id: user_id, chat_id: chat_id})
      |> Repo.insert()
    end)
  end
end
