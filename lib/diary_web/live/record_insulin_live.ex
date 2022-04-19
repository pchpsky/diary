defmodule DiaryWeb.RecordInsulinLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  alias Diary.Settings

  @impl true
  def mount(_params, _session, socket) do
    now = Timex.now(socket.assigns[:tz])

    changeset =
      Metrics.change_insulin(%Metrics.Insulin{
        user_id: socket.assigns.current_user.id,
        taken_at: now,
        units: 10.0
      })

    insulins = Settings.get_settings(socket.assigns.current_user.id) |> Settings.list_insulins()

    {:ok,
     assign(socket,
       changeset: changeset,
       insulins: insulins
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DiaryWeb.InsulinComponents.insulin_form changeset={@changeset} insulins={@insulins} />
    """
  end

  @impl true
  def handle_event("save", %{"insulin" => insulin}, socket) do
    attrs = insulin_attributes(socket, insulin)

    Metrics.record_insulin(socket.assigns.current_user.id, attrs)

    DiaryWeb.Toast.push(socket, "Saved.")

    {:noreply, push_redirect(socket, to: "/insulin")}
  end

  def handle_event("add_notes", %{"notes" => notes}, socket) do
    changeset = Ecto.Changeset.put_change(socket.assigns[:changeset], :notes, notes)

    {:noreply, socket |> assign(:changeset, changeset) |> DiaryWeb.Modal.close("record_insulin_notes")}
  end

  defp insulin_attributes(socket, insulin) do
    taken_at =
      Timex.parse!(~s(#{insulin["taken_at_date"]}T#{insulin["taken_at_time"]}), "{YYYY}-{0M}-{0D}T{h24}:{m}")
      |> Timex.to_datetime(socket.assigns[:tz])
      |> Timex.to_naive_datetime()

    %{
      "insulin_id" => insulin["insulin_id"],
      "notes" => insulin["notes"],
      "taken_at" => taken_at,
      "units" => insulin["units"]
    }
  end
end
