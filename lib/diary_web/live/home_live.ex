defmodule DiaryWeb.HomeLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  import Diary.Time

  @impl true
  def mount(_parms, _session, socket) do
    user = socket.assigns.current_user
    glucose_units = Diary.Settings.get_glucose_units(user.id)

    latest_insulin = Metrics.latest_insulin(user.id) |> Diary.Repo.preload(:insulin)
    latest_glucose = Metrics.latest_glucose(user.id)

    {:ok, assign(socket, latest_insulin: latest_insulin, latest_glucose: latest_glucose, glucose_units: glucose_units)}
  end

  defp format_time(time) do
    Timex.format!(time, "{h24}:{m} - {WDshort}, {D} {Mshort}")
  end

  @impl true
  def handle_event("redirect", %{"to" => to}, socket) do
    {:noreply, push_redirect(socket, to: to)}
  end

  defp format_units(:mmol_per_l), do: "mmol/L"
  defp format_units(:mg_per_dl), do: "mg/dL"
end
