defmodule DiaryWeb.Schema do
  @moduledoc false
  use Absinthe.Schema

  alias DiaryWeb.Schema

  import_types(Schema.Accounts)

  query do
    import_fields(:get_current_user)
  end

  mutation do
    import_fields(:session_mutations)
    import_fields(:user_mutations)
  end
end
