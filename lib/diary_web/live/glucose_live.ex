defmodule DiaryWeb.GlucoseLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  alias Diary.Metrics.GlucoseUnitsIso
  alias Diary.Settings
  import Diary.Time

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    tz = socket.assigns.tz
    glucose_units = Settings.get_glucose_units(user_id)

    grouped =
      user_id
      |> Metrics.list_glucose()
      |> Metrics.group_by_local_date(:measured_at, tz)

    {:ok, assign(socket, records: grouped, selected_record: nil, today: Timex.today(tz), glucose_units: glucose_units)}
  end

  @impl true
  def handle_event("show_details", %{"id" => id}, socket) do
    record = Metrics.get_glucose!(id)

    socket =
      socket
      |> assign(:selected_record, record)
      |> DiaryWeb.Modal.open("glucose_record_details")

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    user_id = socket.assigns.current_user.id
    tz = socket.assigns.tz

    Metrics.delete_insulin(user_id, id)

    new_records =
      user_id
      |> Metrics.list_glucose()
      |> Metrics.group_by_local_date(:measured_at, tz)

    socket =
      socket
      |> assign(:selected_record, nil)
      |> assign(:records, new_records)
      |> DiaryWeb.Modal.close("insulin_glucose_details")

    {:noreply, socket}
  end

  defp day_divider(assigns) do
    ~H"""
    <div class="divider">
      <%= Timex.format!(@date, "{WDshort}, {D} {Mshort}") %>
    </div>
    """
  end

  defp format_units(:mmol_per_l), do: "mmol/L"
  defp format_units(:mg_per_dl), do: "mg/dL"
end
