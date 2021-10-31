defmodule DiaryWeb.Modal do
  use Phoenix.LiveComponent

  def mount(socket) do
    socket
    |> assign_new(:header, fn -> [] end)
    |> assign_new(:footer, fn -> [] end)
    |> assign_new(:state, fn -> :closed end)
    |> Result.ok()
  end

  def handle_event("close", _, socket) do
    {:noreply, assign(socket, :state, :closed)}
  end

  def handle_event("open", _, socket) do
    {:noreply, assign(socket, :state, :open)}
  end

  defp targets(id, target) do
    [id, target]
    |> Enum.filter(& &1)
    |> Enum.map(&"##{&1}")
    |> Enum.join(",")
  end
end
