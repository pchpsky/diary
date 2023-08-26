defmodule DiaryWeb.Schema.ChangesetHelpers do
  @moduledoc """
  Helpers for rendering Ecto changeset in graph
  """

  def render_invalid_changeset(%Ecto.Changeset{} = changeset),
    do: render_invalid_changeset(changeset, "Unprocessable Entity")

  def render_invalid_changeset(v), do: v

  def render_invalid_changeset(%Ecto.Changeset{} = changeset, message) do
    %{
      message: message,
      fields: translate_errors(changeset),
      code: 422
    }
  end

  def translate_errors(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(
      changeset,
      &translate_error/1
    )
  end

  defp translate_error({msg, opts}) do
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
