defmodule DiaryWeb.RecordGlucoseLive do
  use DiaryWeb, :live_view

  alias Diary.Metrics
  alias Diary.Metrics.GlucoseUnitsIso
  alias Diary.Settings

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    now = Timex.now(socket.assigns.tz)
    glucose_units = Settings.get_glucose_units(user_id)
    default_units = GlucoseUnitsIso.from_default(90, glucose_units)

    changeset =
      Metrics.change_glucose(%Metrics.Glucose{
        user_id: socket.assigns.current_user.id,
        measured_at: now,
        units: default_units,
        status: :general
      })

    {:ok, assign(socket, changeset: changeset, glucose_units: glucose_units)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <DiaryWeb.GlucoseComponents.glucose_form changeset={@changeset} />
    """
  end

  @impl true
  def handle_event("save", %{"glucose" => glucose}, socket) do
    attrs = glucose_attributes(socket, glucose)

    {:ok, _} = Metrics.record_glucose(socket.assigns.current_user.id, attrs)

    DiaryWeb.Toast.push(socket, "Saved.")

    {:noreply, push_redirect(socket, to: "/glucose")}
  end

  def handle_event("add_notes", %{"notes" => notes}, socket) do
    changeset = Ecto.Changeset.put_change(socket.assigns.changeset, :notes, notes)

    {:noreply, socket |> assign(:changeset, changeset) |> DiaryWeb.Modal.close("record_glucose_notes")}
  end

  defp glucose_attributes(socket, glucose) do
    measured_at =
      Timex.parse!(~s(#{glucose["measured_at_date"]}T#{glucose["measured_at_time"]}), "{YYYY}-{0M}-{0D}T{h24}:{m}")
      |> Timex.to_datetime(socket.assigns.tz)
      |> Timex.to_naive_datetime()

    %{
      "notes" => glucose["notes"],
      "measured_at" => measured_at,
      "units" => glucose["units"] |> String.to_float() |> GlucoseUnitsIso.to_default(socket.assigns.glucose_units),
      # TODO: set status
      "status" => "general"
    }
  end
end
