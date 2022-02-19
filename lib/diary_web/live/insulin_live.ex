defmodule DiaryWeb.InsulinLive do
  @moduledoc false
  use DiaryWeb, :live_view
  alias Diary.Metrics
  alias Diary.Settings

  @impl true
  def mount(_parms, _session, socket) do
    user_id = socket.assigns.current_user.id
    tz = socket.assigns[:timezone] || "UTC"

    insulins =
      user_id
      |> Settings.get_settings()
      |> Settings.list_insulins()
      |> Enum.group_by(& &1.id)

    make_record = fn data ->
      %{
        taken_at: to_local_time(data.taken_at, tz),
        insulin: hd(insulins[data.insulin_id]),
        units: data.units,
        notes: data.notes
      }
    end

    grouped =
      user_id
      |> Metrics.list_insulins()
      |> Enum.group_by(&Timex.to_date(to_local_time(&1.taken_at, tz)), make_record)
      |> Enum.sort_by(&elem(&1, 0), &>/2)

    {:ok, assign(socket, records: grouped, today: Timex.today(tz))}
  end

  defp to_local_time(dt, timezone) do
    dt
    |> Timex.to_datetime()
    |> Timex.to_datetime(timezone || "UTC")
  end

  defp show_insulin(assigns) do
    ~H"""
    <div class="flex my-4 items-center justify-between">
      <div class="flex items-center">
        <div class="w-5 h-5 inline-block mr-2 rounded-full" style={"background-color: #{@record.insulin.color}"}></div>
        <div><span class="font-bold"><%= @record.units %></span> units of <%= @record.insulin.name %></div>
      </div>
      <div class="flex items-center">
        <%= if @record.notes do %>
          <.icon name={:document_text} class="h-5 w-5 mr-2"/>
        <% end %>
        <div class="w-16">
          <%= Timex.format!(@record.taken_at, "{h24}:{m}") %>
        </div>
      </div>
    </div>
    """
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
