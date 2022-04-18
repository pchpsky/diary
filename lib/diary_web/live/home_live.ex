defmodule DiaryWeb.HomeLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics

  @impl true
  def mount(_parms, _session, socket) do
    user = socket.assigns.current_user

    latest_insulin = Metrics.latest_insulin(user.id) |> Diary.Repo.preload(:insulin)

    {:ok, assign(socket, latest_insulin: latest_insulin)}
  end

  defp format_time(time) do
    Timex.format!(time, "{h24}:{m} - {WDshort}, {D} {Mshort}")
  end

  defp to_local_time(dt, timezone) do
    dt
    |> Timex.to_datetime()
    |> Timex.to_datetime(timezone || "UTC")
  end

  @impl true
  def handle_event("redirect", %{"to" => to}, socket) do
    {:noreply, push_redirect(socket, to: to)}
  end
end
