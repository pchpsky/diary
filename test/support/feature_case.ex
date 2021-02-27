defmodule DiaryWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      import DiaryWeb.FeatureCase.SetupSession
      import DiaryWeb.QueryHelpers
      import DiaryWeb.AccountsHelpers
    end
  end

  defmodule SetupSession do
    defmacro setup_session(session, do: block) do
      quote do
        setup %{session: unquote(session)} do
          new_session = unquote(block)
          [session: new_session]
        end
      end
    end
  end
end
