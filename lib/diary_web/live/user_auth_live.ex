defmodule DiaryWeb.UserAuthLive do
  import Phoenix.LiveView
  import Phoenix.Component
  alias Diary.Accounts

  def on_mount(:default, _params, session, socket) do
    with %{"user_token" => token} <- session,
         %Accounts.User{} = user <- Accounts.get_user_by_session_token(token) do
      {:cont, assign_new(socket, :current_user, fn -> user end)}
    else
      _ -> {:halt, redirect(socket, to: "/sign_in")}
    end
  end
end
