defmodule DiaryWeb.Schema.ChangesetHelpers do
  @moduledoc """
  Helpers for rendering Ecto changeset in graph
  """

  def translate_errors(%Ecto.Changeset{} = changeset) do
    Ecto.Changeset.traverse_errors(
      changeset,
      &DiaryWeb.ErrorHelpers.translate_error/1
    )
  end
end
