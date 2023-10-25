defmodule Diary.GoogleIdToken.KeysManager do
  use GenServer
  require Logger

  @refresh_skew_seconds 5 * 60

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{keys: [], expires_at: :os.system_time(:seconds)}}
  end

  def get_keys() do
    GenServer.call(__MODULE__, :get_keys)
  end

  def handle_call(:get_keys, _from, state) do
    state =
      if expired?(state.expires_at) || Enum.empty?(state.keys) do
        Logger.debug("Refreshing Google public keys")

        refresh_keys(state)
        |> tap(fn result ->
          Logger.debug("Google public keys will expire at #{Timex.from_unix(result.expires_at)}")
        end)
      else
        state
      end

    {:reply, state.keys, state}
  end

  defp expired?(expires_at) do
    expires_at < :os.system_time(:seconds) + @refresh_skew_seconds
  end

  defp refresh_keys(state) do
    {:ok, keys_response} = request_keys()

    {:ok, expires_at} = read_expiration(keys_response)

    keys =
      keys_response
      |> Map.get(:body)
      |> Jason.decode!()
      |> Map.get("keys")

    Map.merge(state, %{keys: keys, expires_at: expires_at})
  end

  defp request_keys do
    Tesla.get("https://www.googleapis.com/oauth2/v3/certs")
  end

  defp read_expiration(response) do
    response
    |> Tesla.get_header("expires")
    |> Timex.parse("{RFC1123}")
    |> Result.map(&Timex.to_unix/1)
  end
end
