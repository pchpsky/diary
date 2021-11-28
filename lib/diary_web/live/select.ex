defmodule DiaryWeb.Select do
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  def mount(socket) do
    {:ok, socket}
  end

  def selected(form, field) do
    form.data |> Map.get(field)
  end

  def hide(js \\ %Phoenix.LiveView.JS{}, id) do
    # TODO: add transitions
    Phoenix.LiveView.JS.hide(js, to: "##{id}_options")
  end

  def toggle(js \\ %Phoenix.LiveView.JS{}, id) do
    # TODO: add transitions
    Phoenix.LiveView.JS.toggle(js, to: "##{id}_options")
  end

  def select(js \\ %Phoenix.LiveView.JS{}, id, {name, value}) do
    option = %{name: name, value: value}

    js
    |> Phoenix.LiveView.JS.hide(to: "##{id}_options")
    |> Phoenix.LiveView.JS.dispatch("selected", to: "##{id}", detail: option)
    |> Phoenix.LiveView.JS.dispatch("selected", to: "##{id}_selected", detail: option)
  end
end
