defmodule DiaryWeb.Schema.UserTypes do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias DiaryWeb.Resolvers

  @desc "A user"
  object :user do
    field :email, :string
  end

  object :get_current_user do
    @desc """
    get current user info
    """

    field :current_user, :user do
      resolve(&Resolvers.Accounts.current_user/2)
    end
  end

  object :create_user_mutation do
    @desc """
    create user
    """

    field :create_user, :user do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))

      resolve(&Resolvers.Accounts.create_user/3)
    end
  end

  object :login_mutation do
    @desc """
    login with the params
    """

    field :create_session, :session do
      arg(:email, non_null(:string))
      arg(:password, non_null(:string))
      resolve(&Resolvers.Accounts.login/2)
    end
  end

  @desc "session value"
  object :session do
    field(:token, :string)
    field(:user, :user)
  end
end
