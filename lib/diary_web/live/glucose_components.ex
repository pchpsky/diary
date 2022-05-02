defmodule DiaryWeb.GlucoseComponents do
  use DiaryWeb, :component

  def glucose_form(assigns) do
    ~H"""
    <.form let={f} for={@changeset} class="mb-2 p-3 px-5" phx-submit="save">
      <div class="mb-4 flex justify-center" phx-hook="NumberInput" id="glucose-units-input">
        <div class="w-10"></div>
        <%= text_input(f, :units,
          class: "input input-bordered input-lg p-1 h-24 w-44 text-right text-7xl",
          required: true,
          onfocus: "this.select();"
        ) %>
        <div class="flex flex-col justify-between my-3 ml-2">
          <button type="button" phx-click={JS.dispatch("inc", to: "#glucose_units")}>
            <.icon name={:plus_circle} class="h-8 w-8" outlined={true} />
          </button>
          <button type="button" phx-click={JS.dispatch("dec", to: "#glucose_units")}>
            <.icon name={:minus_circle} class="h-8 w-8" outlined={true} />
          </button>
        </div>
      </div>

      <div id="measured-at-pickr" class="mb-4 pickr items-center w-full flex" phx-hook="TimePickr">
        <.icon name={:clock} class="h-6 w-6 mr-2 flex-none" />
        <%= text_input(f, :measured_at_time,
          value: Timex.format!(f.data.measured_at, "{h24}:{m}"),
          class: "input input-bordered w-full",
          "data-input": true,
          required: true
        ) %>
      </div>

      <div id="measured-on-pickr" class="mb-4 pickr flex items-center w-full" phx-hook="DatePickr">
        <.icon name={:calendar} class="h-6 w-6 mr-2 flex-none" />
        <%= date_input(f, :measured_at_date,
          value: Timex.format!(f.data.measured_at, "{YYYY}-{0M}-{0D}"),
          class: "input input-bordered w-full",
          "data-input": true,
          required: true
        ) %>
      </div>

      <div class="mb-4 w-full">
        <div class="flex items-center w-full">
          <.icon name={:document_text} class="h-6 w-6 mr-2 flex-none" />
          <%= hidden_input(f, :notes) %>
          <button
            type="button"
            class="input input-bordered w-full text-left"
            phx-click={DiaryWeb.Modal.JS.open("record_glucose_notes")}
          >
            <%= if blank?(@changeset.changes[:notes]) do %>
              <span class="text-grey-400">Add notes</span>
            <% else %>
              <%= @changeset.changes[:notes] %>
            <% end %>
          </button>
        </div>
      </div>

      <div class="flex fixed bottom-0 inset-x-0 justify-center mb-3">
        <%= submit("Save", class: "btn btn-primary btn-wide") %>
      </div>
    </.form>

    <.modal id="record_glucose_notes">
      <.modal_title>Edit notes</.modal_title>

      <form phx-submit="add_notes">
        <textarea name="notes" class="textarea textarea-bordered w-full"><%= @changeset.changes[:notes] %></textarea>
        <.modal_actions>
          <button type="submit" class="btn btn-primary">Save</button>
          <button type="button" class="btn" phx-click={DiaryWeb.Modal.JS.close("record_glucose_notes")}>Close</button>
        </.modal_actions>
      </form>
    </.modal>
    """
  end

  defp blank?(val) do
    val == nil || String.trim(val) == ""
  end
end
