defmodule Diary.MetricsFixtures do
  alias Diary.Metrics.Insulin
  alias Diary.Metrics.Glucose

  def insulin_record_fixture(user_id, insulin_id, attrs \\ %{}) do
    {:ok, insulin_record} =
      %Insulin{
        user_id: user_id,
        insulin_id: insulin_id,
        units: 10.0,
        taken_at: ~N[2023-01-01 12:00:00]
      }
      |> Insulin.changeset(attrs)
      |> Diary.Repo.insert()

    insulin_record
  end

  def glucose_record_fixture(user_id, attrs \\ %{}) do
    {:ok, glucose_record} =
      %Glucose{
        user_id: user_id,
        units: 10.0,
        measured_at: ~N[2023-01-01 12:00:00],
        status: :general
      }
      |> Glucose.changeset(attrs)
      |> Diary.Repo.insert()

    glucose_record
  end
end
