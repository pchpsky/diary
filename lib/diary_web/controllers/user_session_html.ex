defmodule DiaryWeb.UserSessionHTML do
  use DiaryWeb, :html

  def new(assigns) do
    ~H"""
    <%= title("Sign in") %>

    <%= form_for @conn, ~p"/sign_in", [as: :user], fn f -> %>
      <%= if @error_message do %>
        <%= alert_error(@error_message) %>
      <% end %>

      <div class="form-control">
        <%= label f, :email, class: "label" do %>
          <span class="label-text">Email</span>
        <% end %>
        <%= email_input(f, :email, class: "input input-bordered w-full", placeholder: "email") %>
      </div>

      <div class="form-control">
        <%= label f, :password, class: "label" do %>
          <span class="label-text">Password</span>
        <% end %>
        <%= password_input(f, :password, class: "input input-bordered w-full w-full", placeholder: "password") %>
      </div>

      <div class="form-control">
        <%= label f, :remember_me, class: "cursor-pointer label" do %>
          <span class="label-text">Keep me logged in for 60 days</span>
          <%= checkbox(f, :remember_me, class: "checkbox") %>
        <% end %>
      </div>

      <%= submit("Sign in", class: "btn btn-primary btn-block") %>
    <% end %>

    <p class="text-center p-4">
      <%= link("Create account", to: ~p"/sign_up", class: "link link-accent") %>
    </p>
    """
  end

  defp title(text) do
    assigns = %{title: text}

    ~H"""
    <h1 class="text-3xl font-bold my-2"><%= @title %></h1>
    """
  end

  defp alert_error(message) do
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
