defmodule DiaryWeb.QueryHelpers do
  @moduledoc false
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
