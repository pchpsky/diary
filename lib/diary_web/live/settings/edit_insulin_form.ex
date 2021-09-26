defmodule DiaryWeb.Settings.EditInsulinForm do
  use DiaryWeb, :live_component

  alias Diary.Settings

  def update(assigns, socket) do
    {:ok, assign(socket, insulin_changeset: Settings.change_insulin(assigns[:insulin]))}
  end

  def render(assigns) do
    ~H"""
    <div class="rounded-md bg-th-grey-1 cursor-pointer">
      <.form let={f} for={@insulin_changeset} phx-submit="create">
        <div class="flex p-3 items-center">
          <div class="flex-none h-6 w-4 mr-3">
            <%= color_input f, :color, class: "h-4 w-4 my-1 bg-th-grey-1" %>
          </div>
          <%= text_input f, :name, placeholder: "Name", required: true, class: "flex-grow border-b border-grey-600 bg-th-grey-1 outline-none min-w-0" %>
          <%= submit "Add", class: "flex-none ml-3 w-20 h-6 rounded-full border border-grey-400 text-sm font-bold" %>
        </div>
      </.form>
    </div>
    """
  end
end
