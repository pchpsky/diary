defmodule Diary.Metrics.Insulin do
  @moduledoc false
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

  use Diary.Pagination, {:taken_at, :id}

  @derive Inspect
  schema "insulin_metrics" do
    belongs_to :insulin, Diary.Settings.Insulin
    field :notes, :string
    field :taken_at, :naive_datetime
    field :units, :float
    field :cursor, :string, virtual: true
    belongs_to :user, Diary.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(insulin, attrs) do
    insulin
    |> cast(attrs, [:units, :insulin_id, :taken_at, :notes])
    |> validate_required([:units, :insulin_id, :taken_at])
    |> foreign_key_constraint(:insulin_id)
  end
end
