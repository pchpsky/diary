defmodule Diary.Metrics.Insulin do
  @moduledoc false
  import Ecto.Query
  use Ecto.Schema
  import Ecto.Changeset

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

  @behaviour Diary.Pagination

  @impl true
  def paginate(query, limit, nil) do
    query
    |> order_by([i], desc: :taken_at)
    |> order_by([i], desc: :id)
    |> limit(^limit)
  end

  def paginate(query, limit, cursor) do
    [id, taken_at] = String.split(cursor, "#")

    query
    |> order_by([i], desc: :taken_at)
    |> order_by([i], desc: :id)
    |> where([i], i.taken_at < ^taken_at or (i.taken_at == ^taken_at and i.id < ^id))
    |> limit(^limit)
  end

  @impl true
  def make_cursor(%__MODULE__{taken_at: taken_at, id: id}) do
    "#{id}##{taken_at}"
  end

  @impl true
  def select_cursor(query) do
    select_merge(query, [i], %{i | cursor: fragment("CONCAT(?, '#', ?)", i.id, i.taken_at)})
  end

  def by_user(query, %{id: user_id}) do
    where(query, user_id: ^user_id)
  end
end
