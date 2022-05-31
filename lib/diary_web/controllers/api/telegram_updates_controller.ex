defmodule DiaryWeb.Api.TelegramUpdatesController do
  use DiaryWeb, :controller

  plug :validate_token

  def handle(conn, %{"message" => message} = payload) do
    handle_command(message["text"], payload)

    json(conn, %{})
  end

  def validate_token(conn, _) do
    token = Application.fetch_env!(:diary, Diary.Telegram)[:token]

    if token != conn.params["token"] do
      conn
      |> put_status(:not_found)
      |> json(%{error: "not found"})
      |> halt()
    else
      conn
    end
  end

  defp handle_command("/start " <> token, payload) do
    chat_id = chat_id(payload)

    token
    |> Diary.Telegram.lookup_token()
    |> Result.from_optional()
    |> Result.tap_error(fn _ -> respond_token_not_found(chat_id) end)
    |> Result.and_then(fn user_id -> Diary.Telegram.connect(user_id, chat_id) end)
    |> Result.fold(
      fn :already_connected -> respond_already_connected(chat_id) end,
      fn _ -> respond_connected(chat_id) end
    )
  end

  defp chat_id(payload) do
    get_in(payload, ["message", "chat", "id"])
  end

  defp respond_token_not_found(chat_id) do
    Diary.Telegram.send_message(chat_id, "We can not identify you. Please, try again.")
  end

  defp respond_already_connected(chat_id) do
    Diary.Telegram.send_message(chat_id, "User is already connected to another chat.")
  end

  defp respond_connected(chat_id) do
    Diary.Telegram.send_message(chat_id, "You have been successfully connected.")
  end
end
