defmodule Diary.Pagination do
  defmacro __using__({field1, field2}) do
    quote do
      import Ecto.Query

      def paginate(query, limit, nil) do
        query
        |> order_by([t], desc: unquote(field1))
        |> order_by([t], desc: unquote(field2))
        |> limit(^limit)
      end

      def paginate(query, limit, cursor) do
        [value1, value2] = String.split(cursor, "#")

        query
        |> order_by([t], desc: unquote(field1))
        |> order_by([t], desc: unquote(field2))
        |> where(
          [t],
          field(t, unquote(field1)) < ^value1 or
            (field(t, unquote(field1)) == ^value1 and field(t, unquote(field2)) < ^value2)
        )
        |> limit(^limit)
      end

      def make_cursor(%{unquote(field1) => value1, unquote(field2) => value2}) do
        "#{value1}##{value2}"
      end

      def select_cursor(query) do
        select_merge(query, [t], %{
          t
          | cursor:
              fragment(
                "CONCAT(?, '#', ?)",
                field(t, unquote(field1)),
                field(t, unquote(field2))
              )
        })
      end
    end
  end
end
