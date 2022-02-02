defmodule DiaryWeb.SessionViewHelpers do
  @moduledoc """
  Helpers for session views
  """

  use Phoenix.Component

  def title(text) do
    assigns = %{title: text}

    ~H"""
    <h1 class="text-3xl font-bold my-2"><%= @title %></h1>
    """
  end

  def alert_error(message) do
    assigns = %{message: message}

    ~H"""
    <div class="alert alert-error">
      <label>
        <p class="text-sm">
          <%= @message %>
        </p>
      </label>
    </div>
    """
  end
end
