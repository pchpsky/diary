defmodule Diary.Metrics do
  @moduledoc """
  Metrics context
  """

  import Ecto.Query, warn: false
  alias Diary.Repo
  alias Diary.Metrics.Insulin
  alias Diary.Metrics.Glucose

  def get_insulin!(id), do: Repo.get!(Insulin, id)

  def get_insulin(id), do: Repo.get(Insulin, id)

  def list_insulins(user_id) do
    Insulin
    |> where(user_id: ^user_id)
    |> order_by(desc: :taken_at)
    |> Repo.all()
  end

  def latest_insulin(user_id) do
    Insulin
    |> where(user_id: ^user_id)
    |> last(:taken_at)
    |> Repo.one()
  end

  def change_insulin(%Insulin{} = insulin, attrs \\ %{}) do
    Insulin.changeset(insulin, attrs)
  end

  def record_insulin(user_id, data) do
    %Insulin{user_id: user_id}
    |> Insulin.changeset(data)
    |> Repo.insert()
  end

  def update_insulin(insulin, data) do
    insulin
    |> Insulin.changeset(data)
    |> Repo.update()
  end

  def delete_insulin(user_id, id) do
    Insulin
    |> where(id: ^id, user_id: ^user_id)
    |> Repo.delete_all()
  end

  def get_glucose!(id), do: Repo.get!(Glucose, id)

  def get_glucose(id), do: Repo.get(Glucose, id)

  def list_glucose(user_id) do
    Glucose
    |> where(user_id: ^user_id)
    |> order_by(desc: :measured_at)
    |> Repo.all()
  end

  def latest_glucose(user_id) do
    Glucose
    |> where(user_id: ^user_id)
    |> last(:measured_at)
    |> Repo.one()
  end

  def change_glucose(%Glucose{} = glucose, attrs \\ %{}) do
    Glucose.changeset(glucose, attrs)
  end

  def record_glucose(user_id, data) do
    %Glucose{user_id: user_id}
    |> Glucose.changeset(data)
    |> Repo.insert()
  end

  def update_glucose(glucose, data) do
    glucose
    |> Glucose.changeset(data)
    |> Repo.update()
  end

  def delete_glucose(user_id, id) do
    Glucose
    |> where(id: ^id, user_id: ^user_id)
    |> Repo.delete_all()
  end

  def group_by_local_date(records, col, tz) do
    records
    |> Enum.group_by(&Diary.Time.to_local_date(Map.fetch!(&1, col), tz))
    |> Enum.sort_by(&elem(&1, 0), &(Date.compare(&1, &2) == :gt))
  end
end
