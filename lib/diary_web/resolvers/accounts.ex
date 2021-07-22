defmodule DiaryWeb.Resolvers.Accounts do
  @moduledoc false
  alias Diary.Accounts
  alias Diary.Accounts.User
  import DiaryWeb.Schema.ChangesetHelpers

  def current_user(_args, %{context: %{current_user: user}}),
    do: Result.ok(user)

  def current_user(_args, _context),
    do: Result.error(message: "Not Authorized", code: 401)

  def create_user(_parent, args, _context) do
    if String.contains?(args[:email], "error"), do: 1 / 0

    args
    |> Accounts.register_user()
    |> Result.map_error(fn changeset ->
      %{
        message: "Unprocessable Entity",
        fields: translate_errors(changeset),
        code: 422
      }
    end)
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
