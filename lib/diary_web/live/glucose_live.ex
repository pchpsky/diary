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

    socket =
      socket
      |> assign(selected_record: nil)
      |> assign(today: Timex.today(tz))
      |> assign(glucose_units: glucose_units)
      |> stream_configure(:records, dom_id: &make_dom_id/1)
      |> load_records()

    {:ok, assign(socket, selected_record: nil)}
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

    socket =
      socket
      |> stream(:records, [], reset: true)
      |> assign(:last_record, nil)
      |> load_records()
      |> assign(:selected_record, nil)
      |> DiaryWeb.Modal.close("insulin_glucose_details")

    {:noreply, socket}
  end

  def handle_event("load_more", _, socket) do
    {:noreply, load_records(socket)}
  end

  defp load_records(socket) do
    user_id = socket.assigns.current_user.id
    tz = socket.assigns.tz
    last_record = socket.assigns[:last_record]

    records =
      Metrics.Glucose
      |> Diary.Query.by_user(user_id)
      |> Diary.Query.paginated(30, last_record && last_record.cursor)
      |> Diary.Repo.all()

    records_with_dividers =
      if last_record do
        insert_dividers(records, tz)
      else
        records |> insert_dividers(tz) |> add_first_divider(tz)
      end

    socket
    |> assign(:last_record, List.last(records))
    |> stream(:records, records_with_dividers)
  end

  defp day_divider(assigns) do
    ~H"""
    <div class="divider">
      <%= Timex.format!(@date, "{WDshort}, {D} {Mshort}") %>
    </div>
    """
  end

  defp make_dom_id({:record, record}), do: "record-#{record.id}"
  defp make_dom_id({:divider, date}), do: "divider-#{date}"

  defp insert_dividers(records, tz) do
    records
    |> Enum.chunk_every(2, 1)
    |> Enum.flat_map(fn
      [record] ->
        [{:record, record}]

      [record1, record2] ->
        maybe_divider =
          if measured_on_same_date?(record1, record2, tz),
            do: [],
            else: [{:divider, to_local_date(record2.measured_at, tz)}]

        [{:record, record1} | maybe_divider]
    end)
  end

  defp add_first_divider([], _tz), do: []

  defp add_first_divider([{:record, first} | _] = records, tz) do
    if Timex.today(tz) == to_local_date(first.measured_at, tz),
      do: records,
      else: [{:divider, to_local_date(first.measured_at, tz)} | records]
  end

  defp measured_on_same_date?(record1, record2, tz) do
    to_local_date(record1.measured_at, tz) == to_local_date(record2.measured_at, tz)
  end
end
