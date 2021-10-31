defmodule DiaryWeb.Settings.InsulinModal do
  use DiaryWeb, :live_component

  alias Diary.Settings
  alias DiaryWeb.Toast

  def mount(socket) do
    {:ok, assign(socket, insulin: nil, state: :closed)}
  end

  def handle_event("show", %{"id" => id}, socket) do
    insulin = Diary.Settings.get_insulin!(id)

    assigns = [
      state: :open,
      insulin: insulin,
      changeset: Settings.change_insulin(insulin)
    ]

    {:noreply, socket |> assign(assigns)}
  end

  def handle_event("close", _, socket) do
    {:noreply, socket |> assign(state: :closed)}
  end

  def handle_event("save", %{"insulin" => attrs}, socket) do
    insulin = socket.assigns.insulin

    Settings.update_insulin(socket.assigns.insulin, attrs)
    Toast.push(socket, "Updated.")
    Phoenix.PubSub.broadcast!(Diary.PubSub, "settings:insulins:" <> inspect(socket.root_pid), {:updated, insulin.id})

    {:noreply, socket |> assign(state: :closed)}
  end

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.live_component module={DiaryWeb.Modal} id="insulin" state={@state} parent={@id}>
        <:header>
          <h5 class="font-bold mb-4">Edit insulin</h5>
        </:header>
        <.form let={f} for={@changeset} phx-submit="save" phx-target={@myself}>
          <div class="flex items-center mb-5">
            <div class="flex-none h-6 w-6 mr-3">
              <%= color_input f, :color, class: "h-6 w-6 bg-th-grey-1" %>
            </div>
            <%= text_input f, :name, placeholder: "Name", required: true, class: "flex-grow border-b border-grey-500 bg-th-bgc-main outline-none min-w-0" %>
          </div>
          <div class="flex justify-end">
            <button type="submit" class="mr-3 w-20 h-6 rounded-full bg-th-green-1 text-sm font-bold">Save</button>
            <button type="button" class="w-20 h-6 rounded-full border border-grey-500 text-sm font-bold" phx-click="close" phx-target={@myself}>Close</button>
          </div>
        </.form>
      </.live_component>
    </div>
    """
  end
end
