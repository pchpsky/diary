defmodule DiaryWeb.Modal do
  alias DiaryWeb.Modal.JS

  def open(socket, id) do
    Phoenix.LiveView.push_event(socket, "modal:open:#{id}", %{})
  end

  def close(socket, id) do
    Phoenix.LiveView.push_event(socket, "modal:close:#{id}", %{})
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
