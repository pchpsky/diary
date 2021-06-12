defmodule DiaryWeb.Api.UserController do
  use DiaryWeb, :controller

  alias Diary.Accounts
  alias Diary.Guardian

  action_fallback DiaryWeb.Api.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params),
         {:ok, _} <- deliver_confirmation(conn, user),
         {:ok, token, _full_claims} <- Guardian.encode_and_sign(user, %{}) do
      render(conn, "create.json", token: token, email: user.email)
    end
  end

  defp deliver_confirmation(conn, user) do
    Accounts.deliver_user_confirmation_instructions(
      user,
      &Routes.user_confirmation_url(conn, :confirm, &1)
    )
  end
end
