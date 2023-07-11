defmodule Diary.MetricsFixtures do
  alias Diary.Metrics.Insulin

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
end
