defmodule DiaryWeb.TitleHTML do
  use DiaryWeb, :html

  def index(assigns) do
    ~H"""
    <div class="flex items-end justify-between mb-8">
      <img src={~p"/images/logo.png"} alt="Diary" class="h-32 inline" />
      <h1 class="text-6xl font-bold">Diary</h1>
    </div>

    <div class="mb-40">
      <%= if @current_user do %>
        <p class="text-center mb-2">
          Logged in as <%= @current_user.email %>
        </p>
        <%= link("Go to Dashboard", to: ~p"/home", class: "btn btn-primary btn-block my-2") %>
        <%= link("Log out", to: ~p"/users/log_out", method: :delete, class: "btn btn-secondary btn-block my-2") %>
      <% else %>
        <p class="mb-2">&nbsp;</p>
        <%= link("Sign in", to: ~p"/sign_in", class: "btn btn-primary btn-block my-2") %>
        <%= link("Sign up", to: ~p"/sign_up", class: "btn btn-secondary btn-block my-2") %>
      <% end %>
    </div>
    """
  end
end
