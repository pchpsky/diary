defmodule DiaryWeb.Modal do
  use Phoenix.LiveComponent
  alias DiaryWeb.Modal.JS

  @enter_transition {"ease-out duration-300", "opacity-0", "opacity-100"}
  @leave_transition {"ease-in duration-200", "opacity-100", "opacity-0"}

  def open(socket, id) do
    push_event(socket, "modal:open:#{id}", %{})
  end

  def close(socket, id) do
    push_event(socket, "modal:close:#{id}", %{})
  end

  def mount(socket) do
    socket
    |> assign_new(:header, fn -> [] end)
    |> assign_new(:footer, fn -> [] end)
    |> assign_new(:open, fn -> false end)
    |> Result.ok()
  end

  defp hide(js \\ %Phoenix.LiveView.JS{}, id) do
    Phoenix.LiveView.JS.hide(js, to: id, transition: @leave_transition)
  end

  defp show(js \\ %Phoenix.LiveView.JS{}, id) do
    Phoenix.LiveView.JS.show(js, to: id, transition: @enter_transition)
  end
end

defmodule DiaryWeb.Modal.JS do
  alias Phoenix.LiveView.JS

  def open(js \\ %JS{}, id) do
    Phoenix.LiveView.JS.dispatch(js, "modal:open:#{id}", to: "#modal_#{id}")
  end

  def close(js \\ %JS{}, id) do
    Phoenix.LiveView.JS.dispatch(js, "modal:close:#{id}", to: "#modal_#{id}")
  end
end
