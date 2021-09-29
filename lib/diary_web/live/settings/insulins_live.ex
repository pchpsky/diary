defmodule DiaryWeb.Settings.InsulinsLive do
  use DiaryWeb, :live_view

  alias Diary.Settings
  alias DiaryWeb.Toast

  def mount(_, _, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Diary.PubSub, "settings:insulins:" <> inspect(socket.root_pid))
    end

    assigns = [
      page: :settings,
      title: "Insulins",
      back_path: "/settings",
      insulin_changeset: Settings.change_insulin(%Settings.Insulin{color: "#ffd841"}),
      selected: nil
    ]

    socket
    |> load_settings()
    |> load_insulins()
    |> assign(assigns)
    |> Result.ok()
  end

  def view_insulin(assigns) do
    ~H"""
    <div class="p-4 flex items-center">
      <div class="w-4 h-4 inline-block mr-3 rounded-full" style={"background-color: #{@insulin.color}"}></div>
      <div class="border-b border-white border-opacity-0">
        <%= @insulin.name %>
      </div>
    </div>
    """
  end

  def handle_event("create", %{"insulin" => attrs}, socket) do
    Settings.create_insulin(socket.assigns.settings.id, attrs)

    Toast.push(socket, "Created.")

    socket =
      socket
      |> load_insulins()
      |> assign(insulin_changeset: Settings.change_insulin(%Settings.Insulin{color: "#f8e45c"}))

    {:noreply, socket}
  end

  def handle_event("save", %{"insulin" => attrs}, socket) do
    {:noreply, assign(socket, insulin_changeset: Settings.change_insulin(%Settings.Insulin{}, attrs))}
  end

  def handle_event("select", %{"id" => id}, socket) do
    {id, ""} = Integer.parse(id)

    {:noreply, assign(socket, :selected, id)}
  end

  def handle_info({:updated, _id}, socket) do
    {:noreply, load_insulins(socket)}
  end

  def handle_info({:deleted, _id}, socket) do
    {:noreply, load_insulins(socket)}
  end

  defp load_settings(socket) do
    settings = Settings.get_settings(socket.assigns.current_user.id)

    assign(socket, :settings, settings)
  end

  defp load_insulins(socket) do
    assign(socket, :insulins, Settings.list_insulins(socket.assigns.settings))
  end
end