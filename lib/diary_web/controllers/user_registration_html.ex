defmodule DiaryWeb.UserRegistrationHTML do
  use DiaryWeb, :html

  def new(assigns) do
    ~H"""
    <%= title("Create account") %>

    <%= form_for @changeset, ~p"/sign_up", fn f -> %>
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
      <%= link("Log in", to: ~p"/sign_in", class: "link link-accent") %>
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

  defp error_tag(form, field) do
    assigns = %{
      errors: Keyword.get_values(form.errors, field),
      form: form,
      field: field
    }

    ~H"""
    <%= if Enum.any?(@errors) do %>
      <label class="label" phx-feedback-for={input_id(@form, @field)}>
        <%= Enum.map(@errors, fn error -> %>
          <span class="label-text-alt">
            <%= translate_error(error) %>
          </span>
        <% end) %>
      </label>
    <% end %>
    """
  end

  def translate_error({msg, opts}) do
    # When using gettext, we typically pass the strings we want
    # to translate as a static argument:
    #
    #     # Translate "is invalid" in the "errors" domain
    #     dgettext("errors", "is invalid")
    #
    #     # Translate the number of files with plural rules
    #     dngettext("errors", "1 file", "%{count} files", count)
    #
    # Because the error messages we show in our forms and APIs
    # are defined inside Ecto, we need to translate them dynamically.
    # This requires us to call the Gettext module passing our gettext
    # backend as first argument.
    #
    # Note we use the "errors" domain, which means translations
    # should be written to the errors.po file. The :count option is
    # set by Ecto and indicates we should also apply plural rules.
    if count = opts[:count] do
      Gettext.dngettext(DiaryWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(DiaryWeb.Gettext, "errors", msg, opts)
    end
  end
end
