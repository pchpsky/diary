defmodule DiaryWeb.UserRegistrationHTML do
  use DiaryWeb, :html

  def new(assigns) do
    ~H"""
    <%= title("Create account") %>

    <%= form_for @changeset, Routes.user_registration_path(@conn, :create), fn f -> %>
      <%= if @changeset.action do %>
        <%= alert_error("Oops, something went wrong! Please check the errors below.") %>
      <% end %>

      <div class="form-control">
        <%= label f, :email, class: "label" do %>
          <span class="label-text">Email</span>
        <% end %>
        <%= email_input(f, :email,
          class: "input input-bordered w-full #{f.errors[:email] && "input-error"}",
          placeholder: "email"
        ) %>
        <%= error_tag(f, :email) %>
      </div>

      <div class="form-control">
        <%= label f, :password, class: "label" do %>
          <span class="label-text">Password</span>
        <% end %>
        <%= password_input(f, :password,
          class: "input input-bordered w-full #{f.errors[:password] && "input-error"}",
          placeholder: "password"
        ) %>
        <%= error_tag(f, :password) %>
      </div>

      <div class="form-control">
        <%= label f, :password_confirmation, class: "label" do %>
          <span class="label-text">Password confirmation</span>
        <% end %>
        <%= password_input(f, :password_confirmation,
          class: "input input-bordered w-full #{f.errors[:password_confirmation] && "input-error"}",
          placeholder: "password confirmation"
        ) %>
        <%= error_tag(f, :password_confirmation) %>
      </div>

      <%= submit("Submit", class: "btn btn-primary btn-block mt-2") %>
    <% end %>

    <p class="text-center p-4">
      <%= link("Log in", to: Routes.user_session_path(@conn, :new), class: "link link-accent") %>
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
