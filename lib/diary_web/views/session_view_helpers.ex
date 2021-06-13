defmodule DiaryWeb.SessionViewHelpers do
  import Phoenix.HTML

  def title(text) do
    assigns = %{title: text}

    ~E"""
    <h1 class="text-4xl font-bold my-2"><%= @title %></h1>
    """
  end

  def danger_alert(message) do
    assigns = %{message: message}
    ~E"""
    <div class="bg-red-200 text-black text-sm rounded-md p-2">
      <p><%= @message %></p>
    </div>
    """
  end
end
