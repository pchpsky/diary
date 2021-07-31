defmodule DiaryWeb.Schema.AuthMiddleware do
  @behaviour Absinthe.Middleware

  def call(resolution, _config) do
    case resolution.context do
      %{current_user: _} ->
        resolution

      _ ->
        response = Result.error(message: "Not Authorized", code: 401)

        Absinthe.Resolution.put_result(resolution, response)
    end
  end
end
