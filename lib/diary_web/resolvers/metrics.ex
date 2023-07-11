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

  def record_glucose(_parent, args, ctx) do
    ctx
    |> current_user()
    |> Map.get(:id)
    |> Metrics.record_glucose(args[:input])
    |> Result.Error.map(&render_invalid_changeset/1)
  end

  def insulin_records(_parent, args, ctx) do
    user = current_user(ctx)

    Metrics.Insulin
    |> Metrics.Insulin.by_user(user)
    |> Metrics.Insulin.paginate(args[:limit] || 10, args[:cursor])
    |> Metrics.Insulin.select_cursor()
    |> Diary.Repo.all()
    |> Result.ok()
  end
end
