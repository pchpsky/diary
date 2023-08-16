defmodule Diary.Query do
  import Ecto.Query

  def by_user(query, %{id: user_id}) do
    where(query, user_id: ^user_id)
  end

  def by_user(query, user_id) do
    where(query, user_id: ^user_id)
  end

  def by_id(query, ids) when is_list(ids) do
    where(query, [t], t.id in ^ids)
  end

  def by_id(query, id) do
    where(query, id: ^id)
  end

  def paginated(query, limit, cursor \\ nil) do
    source = source_module(query)

    query
    |> source.paginate(limit, cursor)
    |> source.select_cursor()
  end

  defp source_module(queryable) do
    with {_, module} <- Ecto.Queryable.to_query(queryable).from.source, do: module
  end
end
