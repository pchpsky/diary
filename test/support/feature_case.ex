defmodule DiaryWeb.FeatureCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      import DiaryWeb.FeatureCase.SetupSession
      import DiaryWeb.FeatureCase.Assertions
      import DiaryWeb.QueryHelpers
      import DiaryWeb.AccountsHelpers
    end
  end

  defmodule SetupSession do
    @moduledoc false

    defmacro setup_session(session, do: block) do
      quote do
        setup %{session: unquote(session)} do
          new_session = unquote(block)
          [session: new_session]
        end
      end
    end
  end

  defmodule Assertions do
    @moduledoc false
    import Wallaby.Browser
    import ExUnit.Assertions

    def assert_path(session, path) do
      assert current_path(session) == path
      session
    end
  end
end
