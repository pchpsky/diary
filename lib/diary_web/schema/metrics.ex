defmodule DiaryWeb.Schema.Metrics do
  @moduledoc false
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers

  alias DiaryWeb.Resolvers.Metrics, as: MetricsResolvers

  @desc "An insulin record"
  object :insulin_record do
    field :id, non_null(:id)
    field :insulin_id, non_null(:id)

    field :insulin, non_null(:insulin) do
      resolve fn record, _, _ ->
        batch({MetricsResolvers, :insulins_by_id}, record.insulin_id, fn batch_results ->
          {:ok, Map.fetch!(batch_results, record.insulin_id)}
        end)
      end
    end

    field :units, non_null(:float)
    field :taken_at, non_null(:naive_datetime)
    field :notes, :string
    field :cursor, non_null(:string)
  end

  @desc "A glucose record"
  object :glucose_record do
    field :id, non_null(:id)
    field :units, non_null(:float)
    field :measured_at, non_null(:naive_datetime)
    field :status, non_null(:glucose_record_status)
    field :notes, :string
  end

  object :insulin_metrics_queries do
    field :insulin_records, list_of(:insulin_record) do
      arg :limit, :integer
      arg :cursor, :string

      resolve &MetricsResolvers.insulin_records/3
    end
  end

  object :insulin_metrics_mutations do
    field :record_insulin, non_null(:insulin_record) do
      arg :input, non_null(:insulin_record_input)

      resolve &MetricsResolvers.record_insulin/3
    end

    field :delete_insulin_record, non_null(:insulin_record) do
      arg :id, non_null(:id)

      resolve &MetricsResolvers.delete_insulin/3
    end
  end

  object :glucose_metrics_mutations do
    field :record_glucose, non_null(:glucose_record) do
      arg :input, non_null(:glucose_record_input)

      resolve &MetricsResolvers.record_glucose/3
    end
  end

  input_object :insulin_record_input do
    field :insulin_id, non_null(:id)
    field :units, non_null(:float)
    field :taken_at, non_null(:naive_datetime)
    field :notes, :string
  end

  input_object :glucose_record_input do
    field :units, non_null(:float)
    field :measured_at, non_null(:naive_datetime)
    field :status, non_null(:glucose_record_status)
    field :notes, :string
  end

  enum :glucose_record_status do
    value :general
    value :fasting
    value :pre_meal
    value :post_meal
    value :before_sleep
  end
end
