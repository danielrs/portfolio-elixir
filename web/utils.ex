defmodule Portfolio.Utils do
  use Timex

  @spec codify(Strint.t) :: integer
  def codify(string) do
    string
    |> to_char_list
    |> Enum.reduce(fn (x, acc) -> x + acc end)
    |> abs
  end

  @spec format_date(Ecto.Date.type, String.t, atom | nil) :: String.t | no_return
  def format_date(ecto_date, format_string, formatter \\ Timex.Format.DateTime.Formatters.Default) do
    ecto_date
    |> Ecto.Date.to_string
    |> Timex.parse!("{YYYY}-{0M}-{0D}")
    |> Timex.format!(format_string, formatter)
  end
end
