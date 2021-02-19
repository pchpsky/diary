defmodule Diary.Repo do
  use Ecto.Repo,
    otp_app: :diary,
    adapter: Ecto.Adapters.Postgres
end
