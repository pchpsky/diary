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
      &DiaryWeb.ErrorHelpers.translate_error/1
    )
  end
end
