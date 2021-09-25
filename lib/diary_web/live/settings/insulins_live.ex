defmodule DiaryWeb.Settings.InsulinsLive do
  use DiaryWeb, :live_view

  alias Diary.Settings

  def mount(_, _, socket) do
    assigns = [
      page: :settings,
      title: "Insulins",
      back_path: "/settings",
      insulin_changeset: Settings.change_insulin(%Settings.Insulin{color: "#f8e45c"})
    ]

    socket
    |> load_settings()
    |> load_insulins()
    |> assign(assigns)
    |> Result.ok()
  end

  def view_insulin(assigns) do
    ~H"""
    <div class="p-3 flex items-center border-b border-th-bgc-main">
      <div class="w-4 h-4 inline-block mr-3 rounded-full" style={"background-color: #{@insulin.color}"}></div>
      <%= @insulin.name %>
    </div>
    """
  end

  def handle_event("create", %{"insulin" => attrs}, socket) do
    Settings.create_insulin(socket.assigns.settings.id, attrs)

    socket =
      socket
      |> load_insulins()
      |> assign(insulin_changeset: Settings.change_insulin(%Settings.Insulin{color: "#f8e45c"}))

    {:noreply, socket}
  end

  defp load_settings(socket) do
    settings = Settings.get_settings(socket.assigns.current_user.id)

    assign(socket, :settings, settings)
  end

  defp load_insulins(socket) do
    assign(socket, :insulins, Settings.list_insulins(socket.assigns.settings))
  end
end
