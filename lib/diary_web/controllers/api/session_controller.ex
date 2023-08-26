defmodule DiaryWeb.Api.SessionController do
  use DiaryWeb, :controller

  alias Diary.Accounts
  alias Diary.Guardian

  action_fallback DiaryWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password})
      when is_binary(email) and is_binary(password) do
    with {:ok, user} <- authorize(email, password) do
      {:ok, token, _full_claims} = Guardian.encode_and_sign(user, %{})
      render(conn, :show, token: token)
    end
  end

  def create(_, _), do: {:error, :unauthorized}

  defp authorize(email, password) do
    Result.cond(
      Accounts.get_user_by_email_and_password(email, password),
      & &1,
      :unauthorized
    )
  end
end
