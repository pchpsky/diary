defmodule Diary.Pagination do
  @callback paginate(Ecto.Query.t(), integer(), String.t() | nil) :: Ecto.Query.t()

  @callback make_cursor(Ecto.Schema.t()) :: String.t()

  @callback select_cursor(Ecto.Query.t()) :: Ecto.Query.t()
end
