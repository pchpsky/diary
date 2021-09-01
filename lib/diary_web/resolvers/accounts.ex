defmodule DiaryWeb.Resolvers.Accounts do
  @moduledoc false
  alias Diary.Accounts
  alias Diary.Accounts.User
  import DiaryWeb.Schema.ChangesetHelpers

  def current_user(_parent, _args, %{context: %{current_user: user}}),
    do: Result.ok(user)

  def create_user(_parent, args, _context) do
    if String.contains?(args[:email], "error"), do: 1 / 0

    args
    |> Accounts.register_user()
    |> Result.map_error(&render_invalid_changeset/1)
    |> Result.map(fn user ->
      {:ok, jwt, _full_claims} = Diary.Guardian.encode_and_sign(user)
      %{token: jwt, user: user}
    end)
  end

  def login(_parent, %{email: email, password: password}, _resolution) do
    with %User{} = user <- Accounts.get_user_by_email_and_password(email, password),
         {:ok, jwt, _full_claims} <- Diary.Guardian.encode_and_sign(user) do
      Result.ok(%{token: jwt, user: %{email: user.email}})
    else
      _ -> Result.error(%{message: "Incorrect email or password", code: 401})
    end
  end
end
