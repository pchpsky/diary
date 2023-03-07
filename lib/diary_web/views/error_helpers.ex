defmodule DiaryWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML
  use Phoenix.Component

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
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

  @doc """
  Translates an error message using gettext.
  """
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
