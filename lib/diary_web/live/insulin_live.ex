defmodule DiaryWeb.InsulinLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  import Diary.Time

  @impl true
  def mount(_parms, _session, socket) do
    user_id = socket.assigns.current_user.id
    tz = socket.assigns[:tz]

    grouped =
      user_id
      |> Metrics.list_insulins()
      |> Diary.Repo.preload(:insulin)
      |> Metrics.group_by_local_date(:taken_at, tz)

    {:ok, assign(socket, records: grouped, selected_record: nil, today: Timex.today(tz))}
  end

  @impl true
  def handle_event("show_details", %{"id" => id}, socket) do
    record =
      id
      |> Metrics.get_insulin!()
      |> Diary.Repo.preload(:insulin)

    socket =
      socket
      |> assign(:selected_record, record)
      |> DiaryWeb.Modal.open("insulin_record_details")

    {:noreply, socket}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    user_id = socket.assigns.current_user.id
    tz = socket.assigns[:tz]

    Metrics.delete_insulin(user_id, id)

    new_records =
      user_id
      |> Metrics.list_insulins()
      |> Diary.Repo.preload(:insulin)
      |> Metrics.group_by_local_date(:taken_at, tz)

    socket =
      socket
      |> assign(:selected_record, nil)
      |> assign(:records, new_records)
      |> DiaryWeb.Modal.close("insulin_record_details")

    {:noreply, socket}
  end

  defp day_divider(assigns) do
    ~H"""
    <%= if @date != @today do %>
      <div class="divider">
        <%= Timex.format!(@date, "{WDshort}, {D} {Mshort}") %>
      </div>
    <% end %>
    """
  end
end
