defmodule DiaryWeb.Resolvers.Metrics do
  import DiaryWeb.Schema.ContextHelpers
  import DiaryWeb.Schema.ChangesetHelpers
  alias Diary.Metrics
  alias Diary.Query
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

  def update_insulin(_parent, %{id: id, input: input}, ctx) do
    Metrics.Insulin
    |> Query.by_user(current_user(ctx))
    |> Query.by_id(id)
    |> Diary.Repo.one()
    |> Result.cond(&(&1 != nil), "Insulin record not found")
    |> Result.and_then(fn insulin ->
      insulin
      |> Metrics.update_insulin(input)
      |> Result.Error.map(&render_invalid_changeset/1)
    end)
  end

  def update_glucose(_parent, %{id: id, input: input}, ctx) do
    Metrics.Glucose
    |> Query.by_user(current_user(ctx))
    |> Query.by_id(id)
    |> Diary.Repo.one()
    |> Result.cond(&(&1 != nil), "Glucose record not found")
    |> Result.and_then(fn glucose ->
      glucose
      |> Metrics.update_glucose(input)
      |> Result.Error.map(&render_invalid_changeset/1)
    end)
  end

  def insulin_records(_parent, args, ctx) do
    user = current_user(ctx)

    Metrics.Insulin
    |> Query.by_user(user)
    |> Query.paginated(args[:limit] || 10, args[:cursor])
    # TODO remove when integrity ensured
    |> join(:inner, [i], is in assoc(i, :insulin))
    |> Diary.Repo.all()
    |> Result.ok()
  end

  def glucose_records(_parent, args, ctx) do
    user = current_user(ctx)

    Metrics.Glucose
    |> Query.by_user(user)
    |> Query.paginated(args[:limit] || 10, args[:cursor])
    |> Diary.Repo.all()
    |> Result.ok()
  end

  def delete_insulin(_parent, args, ctx) do
    ctx
    |> current_user()
    |> Map.get(:id)
    |> Metrics.delete_insulin(args[:id])
    |> Result.Error.map(fn
      :not_found ->
        "Insulin record not found"

      error ->
        render_invalid_changeset(error)
    end)
  end

  def delete_glucose(_parent, args, ctx) do
    ctx
    |> current_user()
    |> Metrics.delete_glucose(args[:id])
    |> Result.Error.map(fn
      :not_found ->
        "Glucose record not found"

      error ->
        render_invalid_changeset(error)
    end)
  end

  def insulins_by_id(_, insulin_ids) do
    insulin_ids = Enum.uniq(insulin_ids)

    Diary.Settings.Insulin
    |> Query.by_id(insulin_ids)
    |> Diary.Repo.all()
    |> Map.new(&{&1.id, &1})
  end
end
