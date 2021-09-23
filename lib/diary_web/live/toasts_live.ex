defmodule DiaryWeb.ToastsLive do
  use DiaryWeb, :live_view

  def mount(_, _, socket) do
    if connected?(socket) do
      Phoenix.PubSub.subscribe(Diary.PubSub, "toasts" <> inspect(socket.root_pid))
    end

    {:ok, assign(socket, :toasts, [])}
  end

  def handle_event("close", %{"target" => target_id}, socket) do
    {:noreply, close_toast(socket, target_id)}
  end

  def handle_info({:make_toast, message}, socket) do
    {:noreply, push_toast(socket, message)}
  end

  def handle_info({:close_toast, toast_id}, socket) do
    {:noreply, close_toast(socket, toast_id)}
  end

  defp push_toast(socket, message) do
    toast_id = random_id()
    toasts = socket.assigns.toasts ++ [{toast_id, message}]

    Process.send_after(self(), {:close_toast, toast_id}, 5_000)

    assign(socket, :toasts, toasts)
  end

  defp close_toast(socket, toast_id) do
    toasts = Enum.filter(socket.assigns.toasts, fn {id, _} -> id != toast_id end)

    assign(socket, :toasts, toasts)
  end

  defp random_id do
    Ecto.UUID.generate()
  end
end
