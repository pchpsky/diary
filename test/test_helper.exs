ExUnit.configure(exclude: [:skip, :feature])
ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Diary.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, DiaryWeb.Endpoint.url())
Logger.put_application_level(:absinthe, :info)
