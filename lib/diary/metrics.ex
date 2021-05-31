defmodule Diary.Metrics do
  import Ecto.Query, warn: false
  alias Diary.Repo
  alias Diary.Metrics.Insulin

  def get_insulin!(id), do: Repo.get!(Insulin, id)

  def change_insulin(%Insulin{} = insulin, attrs \\ %{}) do
    Insulin.changeset(insulin, attrs)
  end
end
