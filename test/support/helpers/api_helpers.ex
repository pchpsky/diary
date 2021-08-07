defmodule Diary.ApiHelpers do
  @moduledoc false
  import Diary.AccountsFixtures
  import Diary.Guardian

  def sign_in(conn, user \\ user_fixture()) do
    {:ok, token, _} = encode_and_sign(user, %{}, token_type: :access)

    Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token)
  end
end
