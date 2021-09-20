alias Diary.{Accounts, Settings}

IEx.configure(inspect: [limit: 10])

defmodule H do
  def ube(email) do
    Accounts.get_user_by_email(email)
  end
end

user = H.ube("pchpsky@outlook.com")
