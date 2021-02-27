defmodule DiaryWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature
      import DiaryWeb.FeatureCase.SetupSession
      import DiaryWeb.FeatureCase.QueryHelpers
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

  defmodule QueryHelpers do
    alias Wallaby.Query

    @spec link_to(binary) :: Wallaby.Query.t()
    def link_to(href) do
      Query.css("a[href='#{href}']")
    end

    @spec link_to(binary, binary) :: Wallaby.Query.t()
    def link_to(href, text) do
      link_to(href)
      |> Query.text(text)
    end
  end
end
