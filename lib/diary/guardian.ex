defmodule Diary.Guardian do
  @moduledoc """
  Auth interface
  """

  use Guardian, otp_app: :diary

  alias Diary.Accounts

  def subject_for_token(resource, _claims) do
    resource.id
    |> to_string()
    |> Result.ok()
  end

  def resource_from_claims(claims) do
    claims["sub"]
    |> Accounts.get_user!()
    |> Result.ok()
  end
end
