defmodule Diary.Telegram.UserTokenLookup do
  use GenServer

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_) do
    {:ok, %{}}
  end

  def issue_token(user_id) do
    GenServer.call(__MODULE__, {:issue_token, user_id})
  end

  def pop_token(token) do
    GenServer.call(__MODULE__, {:pop, token})
  end

  def handle_call({:issue_token, user_id}, _from, state) do
    token = gen_token()
    Process.send_after(self(), {:remove_token, token}, :timer.minutes(30))
    {:reply, token, Map.put(state, token, user_id)}
  end

  def handle_call({:pop, token}, _from, state) do
    {:reply, Map.get(state, token), Map.delete(state, token)}
  end

  def handle_info({:remove_token, token}, state) do
    {:noreply, Map.delete(state, token)}
  end

  defp gen_token(length \\ 32) do
    1..length
    |> Enum.map(fn _ -> Enum.random(Enum.to_list(?A..?Z) ++ Enum.to_list(?a..?z)) end)
    |> List.to_string()
  end
end
