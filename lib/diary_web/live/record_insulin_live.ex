defmodule DiaryWeb.RecordInsulinLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics

  @impl true
  def mount(_params, _session, socket) do
    now =
      case socket.assigns[:timezone] do
        nil -> Timex.now()
        tz -> Timex.now(tz)
      end

    changeset = Metrics.change_insulin(%Metrics.Insulin{user_id: socket.assigns.current_user.id, taken_at: now})
    {:ok, assign(socket, page: :insulin, title: "Record insulin", back_path: "/home", changeset: changeset)}
  end

  def format_time(time) do
    Timex.format!(time, "{WDshort}, {D} {Mshort} {YYYY}, {h24}:{m}")
  end
end
