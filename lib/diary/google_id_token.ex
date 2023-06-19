defmodule Diary.GoogleIdToken do
  alias Diary.GoogleIdToken.KeysManager

  def verify(id_token) do
    {:ok, keys} = KeysManager.get_keys()

    %{"kid" => kid} = Joken.peek_header("id_token")

    key = Enum.find(keys, fn key -> key["kid"] == kid end)

    signer = Joken.Signer.create(key["alg"], key)

    {:ok, claims} = Joken.verify(id_token, signer)

    {:ok, claims}
  end
end
