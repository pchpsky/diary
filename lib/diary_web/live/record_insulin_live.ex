defmodule DiaryWeb.RecordInsulinLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  alias Diary.Settings
  import DiaryWeb.IconHelpers

  @impl true
  def mount(_params, _session, socket) do
    now =
      case socket.assigns[:timezone] do
        nil -> Timex.now()
        tz -> Timex.now(tz)
      end

    changeset =
      Metrics.change_insulin(%Metrics.Insulin{
        user_id: socket.assigns.current_user.id,
        taken_at: now,
        units: 10.0
      })

    insulins = Settings.get_settings(socket.assigns.current_user.id) |> Settings.list_insulins()

    {:ok,
     assign(socket,
       page: :insulin,
       title: "Record insulin",
       back_path: "/home",
       changeset: changeset,
       insulins: insulins
     )}
  end

  @impl true
  def handle_event("inspect", %{"insulin" => insulin}, socket) do
    Timex.parse!(~s(#{insulin["taken_at_date"]}T#{insulin["taken_at_time"]}), "{YYYY}-{0M}-{0D}T{h24}:{m}")
    |> Timex.to_datetime(socket.assigns[:timezone] || "UTC")
    |> IO.inspect()

    IO.inspect(insulin)

    {:noreply, socket}
  end

  def format_time(time) do
    Timex.format!(time, "{WDshort}, {D} {Mshort} {YYYY}, {h24}:{m}")
  end
end
