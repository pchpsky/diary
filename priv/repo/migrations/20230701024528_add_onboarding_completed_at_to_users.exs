defmodule Diary.Repo.Migrations.AddOnboardingCompletedAtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :onboarding_completed_at, :naive_datetime
    end
  end
end
