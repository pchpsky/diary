defmodule DiaryWeb.InsulinLive do
  @moduledoc false
  use DiaryWeb, :live_view
  alias Diary.Metrics

  @impl true
  def mount(_parms, _session, socket) do
    user_id = socket.assigns.current_user.id
    tz = socket.assigns[:timezone] || "UTC"

    grouped =
      user_id
      |> Metrics.list_insulins()
      |> Diary.Repo.preload(:insulin)
      |> Enum.group_by(&Timex.to_date(to_local_time(&1.taken_at, tz)))
      |> Enum.sort_by(&elem(&1, 0), &>/2)

    {:ok, assign(socket, records: grouped, selected_record: nil, today: Timex.today(tz), tz: tz)}
  end

  defp to_local_time(dt, timezone) do
    dt
    |> Timex.to_datetime()
    |> Timex.to_datetime(timezone || "UTC")
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
