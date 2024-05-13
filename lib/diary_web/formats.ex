defmodule DiaryWeb.Formats do
  def glucose_units(:mmol_per_l), do: "mmol/L"
  def glucose_units(:mg_per_dl), do: "mg/dL"

  def local_weekday_and_date(date, tz) do
    date
    |> Diary.Time.to_local_date(tz)
    |> Timex.format!("{WDshort}, {D} {Mshort}")
  end
end
