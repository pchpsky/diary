defmodule DiaryWeb.EditInsulinLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  alias Diary.Settings
  import Diary.Time

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    with {:ok, id} <- Ecto.Type.cast(:id, id),
         insulin when not is_nil(insulin) <- Metrics.get_insulin(id) do
      changeset =
        insulin
        |> Map.update!(:taken_at, &to_local_datetime(&1, socket.assigns[:tz]))
        |> Diary.Repo.preload(:insulin)
        |> Metrics.change_insulin()

      insulins = Settings.get_settings(socket.assigns.current_user.id) |> Settings.list_insulins()

      {:ok,
       assign(socket,
         changeset: changeset,
         insulins: insulins,
         insulin: insulin
       )}
    else
      _ ->
        {:ok, push_redirect(socket, to: "/insulin")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DiaryWeb.InsulinComponents.insulin_form changeset={@changeset} insulins={@insulins} />
    """
  end

  @impl true
  def handle_event("save", %{"insulin" => insulin_params}, socket) do
    attrs = insulin_attributes(socket, insulin_params)

    Metrics.update_insulin(socket.assigns.insulin, attrs)

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
