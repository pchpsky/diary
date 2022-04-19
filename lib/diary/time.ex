defmodule Diary.Time do
  @type date() :: Timex.Types.valid_date()
  @type datetime() :: Timex.Types.valid_datetime()
  @type timezone() :: Timex.Types.valid_timezone()

  @spec to_local_datetime(datetime(), timezone()) :: datetime()
  def to_local_datetime(dt, tz) do
    dt
    |> Timex.to_datetime()
    |> Timex.to_datetime(tz)
  end

  @spec to_local_date(datetime(), timezone()) :: Date.t() | {:error, term}
  def to_local_date(dt, tz) do
    dt
    |> to_local_datetime(tz)
    |> Timex.to_date()
  end
end
