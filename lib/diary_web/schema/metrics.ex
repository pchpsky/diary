defmodule DiaryWeb.Schema.Metrics do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias DiaryWeb.Resolvers.Metrics, as: MetricsResolvers

  @desc "An insulin record"
  object :insulin_record do
    field :id, non_null(:id)
    field :insulin_id, non_null(:id)
    field :units, non_null(:float)
    field :taken_at, non_null(:naive_datetime)
    field :notes, :string
  end

  object :insulin_metrics_mutations do
    field :record_insulin, non_null(:insulin_record) do
      arg :input, non_null(:insulin_record_input)

      resolve &MetricsResolvers.record_insulin/3
    end
  end

  input_object :insulin_record_input do
    field :insulin_id, non_null(:id)
    field :units, non_null(:float)
    field :taken_at, non_null(:naive_datetime)
    field :notes, :string
  end
end
