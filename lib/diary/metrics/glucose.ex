defmodule Diary.Metrics.Glucose do
  use Ecto.Schema
  import Ecto.Changeset

  use Diary.Pagination, {:measured_at, :id}

  schema "glucose_metrics" do
    field :measured_at, :naive_datetime
    field :notes, :string
    field :status, Ecto.Enum, values: [general: 0, fasting: 1, pre_meal: 2, post_meal: 3, before_sleep: 4]
    field :units, :float
    field :cursor, :string, virtual: true
    belongs_to :user, Diary.Accounts.User

    timestamps()
  end

  def changeset(glucose, attrs) do
    glucose
    |> cast(attrs, [:units, :status, :notes, :measured_at])
    |> validate_required([:units, :status, :measured_at])
  end
end
