defmodule DiaryWeb.Schema.Accounts do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias DiaryWeb.Resolvers.Accounts, as: AccountResolvers

  @desc "A user"
  object :user do
    field :email, :string
  end

  object :get_current_user do
    @desc """
    get current user info
    """

    field :current_user, :user do
      resolve(&AccountResolvers.current_user/2)
    end
  end

  object :user_mutations do
    @desc """
    create user
    """

    field :create_user, :session do
      config(skip_auth: true)

      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountResolvers.create_user/3)
    end
  end

  object :session_mutations do
    @desc """
    login with the params
    """

    field :create_session, :session do
      config(skip_auth: true)

      arg(:email, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&AccountResolvers.login/2)
    end
  end

  @desc "session value"
  object :session do
    field(:token, :string)
    field(:user, :user)
  end
end
