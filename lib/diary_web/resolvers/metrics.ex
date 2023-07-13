defmodule DiaryWeb.Resolvers.Metrics do
  import DiaryWeb.Schema.ContextHelpers
  import DiaryWeb.Schema.ChangesetHelpers
  alias Diary.Metrics
  import Ecto.Query

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
    # TODO remove when integrity ensured
    |> join(:inner, [i], is in assoc(i, :insulin))
    |> Diary.Repo.all()
    |> Result.ok()
  end

  def delete_insulin(_parent, args, ctx) do
    ctx
    |> current_user()
    |> Map.get(:id)
    |> Metrics.delete_insulin(args[:id])
    |> Result.Error.map(&render_invalid_changeset/1)
  end

  def insulins_by_id(_, insulin_ids) do
    insulin_ids = Enum.uniq(insulin_ids)

    Diary.Settings.Insulin
    |> where([i], i.id in ^insulin_ids)
    |> Diary.Repo.all()
    |> Map.new(&{&1.id, &1})
  end
end
