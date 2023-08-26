defmodule DiaryWeb.ErrorJSON do
  def show(%{errors: errors}), do: %{errors: errors}

  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end
