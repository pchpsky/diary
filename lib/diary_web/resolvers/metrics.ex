defmodule DiaryWeb.Resolvers.Metrics do
  import DiaryWeb.Schema.ContextHelpers
  import DiaryWeb.Schema.ChangesetHelpers
  alias Diary.Metrics

  def record_insulin(_parent, args, ctx) do
    ctx
    |> current_user()
    |> Map.get(:id)
    |> Metrics.record_insulin(args[:input])
    |> Result.Error.map(&render_invalid_changeset/1)
  end
end
