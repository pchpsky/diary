defmodule Diary.Metrics do
  @moduledoc """
  Metrics context
  """

  import Ecto.Query, warn: false
  alias Diary.Repo
  alias Diary.Metrics.Insulin

  def get_insulin!(id), do: Repo.get!(Insulin, id)

  def get_insulin(id), do: Repo.get(Insulin, id)

  def list_insulins(user_id) do
    Repo.all(
      from i in Insulin,
        where: i.user_id == ^user_id,
        order_by: [desc: i.taken_at]
    )
  end

  def latest_insulin(user_id) do
    Repo.one(
      from i in Insulin,
        where: i.user_id == ^user_id,
        order_by: [desc: i.taken_at],
        limit: 1
    )
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
    Repo.delete_all(from i in Insulin, where: i.id == ^id and i.user_id == ^user_id)
  end
end
