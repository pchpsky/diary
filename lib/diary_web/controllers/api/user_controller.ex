defmodule DiaryWeb.Api.UserController do
  use DiaryWeb, :controller

  alias Diary.Accounts
  alias Diary.Guardian

  action_fallback DiaryWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(user, %{}) do
      render(conn, :show, %{user: %{token: token, email: user.email}})
    end
  end
end
