defmodule DiaryWeb.HomeLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  import Diary.Time

  @impl true
  def mount(_parms, _session, socket) do
    user = socket.assigns.current_user

    latest_insulin = Metrics.latest_insulin(user.id) |> Diary.Repo.preload(:insulin)
    latest_glucose = Metrics.latest_glucose(user.id)

    {:ok, assign(socket, latest_insulin: latest_insulin, latest_glucose: latest_glucose)}
  end

  defp format_time(time) do
    Timex.format!(time, "{h24}:{m} - {WDshort}, {D} {Mshort}")
  end

  @impl true
  def handle_event("redirect", %{"to" => to}, socket) do
    {:noreply, push_redirect(socket, to: to)}
  end
end
