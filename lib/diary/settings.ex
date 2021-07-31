defmodule Diary.Settings do
  @moduledoc """
  Settings context
  """

  import Ecto.Query, warn: false
  alias Diary.Repo
  alias Diary.Settings.Insulin

  @doc """
  Returns all insulins.

  ## Examples

      iex> list_insulins()
      [%Insulin{}, ...]

  """
  def list_insulins() do
    Repo.all(Insulin)
  end

  @doc """
  Gets a single insulin.

  Raises `Ecto.NoResultsError` if the Insulin does not exist.

  ## Examples

      iex> get_insulin!(123)
      %Insulin{}

      iex> get_insulin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_insulin!(id), do: Repo.get!(Insulin, id)

  @doc """
  Creates an insulin.

  ## Examples

      iex> create_insulin(%{field: value})
      {:ok, %Insulin{}}

      iex> create_insulin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_insulin(attrs) do
    %Insulin{}
    |> Insulin.changeset(attrs)
    |> Repo.insert()
  end
end
