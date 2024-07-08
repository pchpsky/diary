defmodule DiaryWeb.EditGlucoseLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  alias Diary.Metrics.GlucoseUnitsIso
  alias Diary.Settings
  import Diary.Time

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    with {:ok, id} <- Ecto.Type.cast(:id, id),
         glucose when not is_nil(glucose) <- Metrics.get_glucose(id) do
      glucose_units = Settings.get_glucose_units(socket.assigns.current_user.id)

      changeset =
        glucose
        |> Map.update!(:measured_at, &to_local_datetime(&1, socket.assigns.tz))
        |> Map.update!(:units, &GlucoseUnitsIso.from_default(&1, glucose_units))
        |> Metrics.change_glucose()

      {:ok,
       assign(socket,
         changeset: changeset,
         glucose: glucose,
         glucose_units: glucose_units
       )}
    else
      _ ->
        {:ok, push_navigate(socket, to: "/glucose")}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DiaryWeb.GlucoseComponents.glucose_form changeset={@changeset} />
    """
  end

  @impl true
  def handle_event("save", %{"glucose" => glucose_params}, socket) do
    attrs = glucose_attributes(socket, glucose_params)

    Metrics.update_glucose(socket.assigns.glucose, attrs)

    DiaryWeb.Toast.push(socket, "Saved.")

    {:noreply, push_navigate(socket, to: "/glucose")}
  end

  def handle_event("add_notes", %{"notes" => notes}, socket) do
    changeset = Ecto.Changeset.put_change(socket.assigns[:changeset], :notes, notes)

    {:noreply, socket |> assign(:changeset, changeset) |> DiaryWeb.Modal.close("record_glucose_notes")}
  end

  defp glucose_attributes(socket, glucose) do
    measured_at =
      Timex.parse!(~s(#{glucose["measured_at_date"]}T#{glucose["measured_at_time"]}), "{YYYY}-{0M}-{0D}T{h24}:{m}")
      |> Timex.to_datetime(socket.assigns[:tz])
      |> Timex.to_naive_datetime()

    %{
      "notes" => glucose["notes"],
      "measured_at" => measured_at,
      "units" => glucose["units"] |> String.to_float() |> GlucoseUnitsIso.to_default(socket.assigns.glucose_units),
      "status" => glucose["status"]
    }
  end
end
