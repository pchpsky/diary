defmodule DiaryWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias DiaryWeb.Schema

  import_types(Schema.Accounts)
  import_types(Schema.Settings)

  query do
    import_fields(:get_current_user)
    import_fields(:settings_queries)
  end

  mutation do
    import_fields(:session_mutations)
    import_fields(:user_mutations)
    import_fields(:settings_mutations)
  end

  def middleware(
        middleware,
        %Absinthe.Type.Field{config: config},
        %Absinthe.Type.Object{identifier: identifier}
      )
      when identifier in [:query, :subscription, :mutation] do
    if config[:skip_auth] do
      middleware
    else
      [Schema.AuthMiddleware | middleware]
    end
  end

  def middleware(middleware, _field, _object) do
    middleware
  end
end
