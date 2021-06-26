defmodule DiaryWeb.Resolvers.Accounts do
  @moduledoc false
  alias Diary.Accounts
  alias Diary.Accounts.User

  def current_user(_args, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def current_user(_args, _context), do: {:error, "Not Authorized"}

  def create_user(_parent, args, _context) do
    Accounts.register_user(args)
  end

  def login(%{email: email, password: password}, _info) do
    with %User{} = user <- Accounts.get_user_by_email_and_password(email, password),
         {:ok, jwt, _full_claims} <- Diary.Guardian.encode_and_sign(user) do
      {:ok, %{token: jwt, user: %{email: user.email}}}
    else
      _ -> {:error, "Incorrect email or password"}
    end
  end
end
