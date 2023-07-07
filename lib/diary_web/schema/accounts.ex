defmodule DiaryWeb.Schema.Accounts do
  @moduledoc false
  use Absinthe.Schema.Notation

  alias DiaryWeb.Resolvers.Accounts, as: AccountResolvers

  @desc "A user"
  object :user do
    field :email, non_null(:string)
    field :onboarding_completed_at, :naive_datetime
  end

  object :get_current_user do
    @desc """
    get current user info
    """

    field :current_user, non_null(:user) do
      resolve &AccountResolvers.current_user/3
    end
  end

  object :user_mutations do
    @desc """
    create user
    """

    field :create_user, non_null(:session) do
      config skip_auth: true

      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &AccountResolvers.create_user/3
    end

    field :complete_onboarding, non_null(:user) do
      arg :completed_at, non_null(:naive_datetime)

      resolve &AccountResolvers.complete_onboarding/3
    end
  end

  object :session_mutations do
    @desc """
    login with the params
    """

    field :create_session, non_null(:session) do
      config skip_auth: true

      arg :email, non_null(:string)
      arg :password, non_null(:string)

      resolve &AccountResolvers.login/3
    end

    field :create_session_by_google_id_token, non_null(:session) do
      config skip_auth: true

      arg :id_token, non_null(:string)

      resolve &AccountResolvers.login_by_google_id_token/3
    end
  end

  @desc "session value"
  object :session do
    field :token, non_null(:string)
    field :user, non_null(:user)
  end
end
