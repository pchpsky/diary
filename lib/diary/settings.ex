defmodule Diary.Settings do
  @moduledoc """
  Settings context
  """

  import Ecto.Query, warn: false
  alias Diary.Repo
  alias Diary.Settings.Insulin
  alias Diary.Settings.UserSettings

  @doc """
  Returns user settings or creates default.

  ## Examples

      iex> get_settings(user_id)
      %UserSettings{}

  """
  def get_settings(user_id) do
    {:ok, settings} =
      default_settings()
      |> UserSettings.changeset(%{user_id: user_id})
      |> Repo.insert(on_conflict: :nothing)

    if is_nil(settings.id) do
      Repo.one(from s in UserSettings, where: s.user_id == ^user_id)
    else
      settings
    end
  end

  defp default_settings do
    %UserSettings{blood_glucose_units: :mmol_per_l}
  end

  def get_glucose_units(user_id) do
    get_settings(user_id).blood_glucose_units
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing user settings.
  """
  def change_settings(settings, attrs \\ %{}) do
    UserSettings.changeset(settings, attrs)
  end

  def update_settings(settings, attrs) do
    settings
    |> UserSettings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns all insulins.

  ## Examples

      iex> list_insulins()
      [%Insulin{}, ...]

  """
  def list_insulins(%UserSettings{id: id}), do: list_insulins(id)

  def list_insulins(settings_id) do
    Repo.all(from i in Insulin, where: i.settings_id == ^settings_id and is_nil(i.deleted_at), order_by: i.inserted_at)
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
  def get_insulin!(id), do: Repo.one!(get_insulin_query(id))

  def get_insulin(id), do: Repo.one(get_insulin_query(id))

  defp get_insulin_query(id) do
    from i in Insulin, where: i.id == ^id and is_nil(i.deleted_at)
  end

  def change_insulin(insulin, attrs \\ %{}) do
    Insulin.changeset(insulin, attrs)
  end

  @doc """
  Creates an insulin.

  ## Examples

      iex> create_insulin(%{field: value})
      {:ok, %Insulin{}}

      iex> create_insulin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_insulin(settings_id, attrs) do
    %Insulin{settings_id: settings_id}
    |> Insulin.changeset(attrs)
    |> Repo.insert()
  end

  def create_insulins(settings_id, insulins) do
    insert_result =
      insulins
      |> Enum.with_index()
      |> Enum.reduce(
        Ecto.Multi.new(),
        fn {attrs, pos}, multi ->
          Ecto.Multi.insert(
            multi,
            pos,
            Insulin.changeset(%Insulin{settings_id: settings_id}, attrs)
          )
        end
      )
      |> Repo.transaction()

    case insert_result do
      {:error, failed_at, error, _} ->
        Result.error({failed_at, error})

      otherwise ->
        otherwise
    end
    |> Result.map(&Map.values/1)
  end

  def update_insulin(insulin, attrs) do
    insulin
    |> Insulin.changeset(attrs)
    |> Repo.update()
  end

  def delete_insulin(insulin) do
    insulin
    |> Insulin.changeset(%{deleted_at: NaiveDateTime.utc_now()})
    |> Repo.update()
  end
end
