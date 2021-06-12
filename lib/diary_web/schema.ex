defmodule DiaryWeb.Schema do
  use Absinthe.Schema

  alias DiaryWeb.Schema

  import_types(Schema.UserTypes)

  query do
    import_fields(:get_current_user)
  end

  mutation do
    import_fields(:login_mutation)
    import_fields(:create_user_mutation)
  end
end
