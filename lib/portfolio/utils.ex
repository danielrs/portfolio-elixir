defmodule Portfolio.Utils do
  @doc """
  Returns the host url configured in the app.
  """
  @spec host() :: String.t
  def host do
    "http://#{Application.get_env(:portfolio, Portfolio.Endpoint)[:url][:host]}"
  end

  @spec codify(Strint.t) :: integer
  def codify(string) when is_binary(string) do
    string
    |> to_char_list
    |> Enum.reduce(0, fn (x, acc) -> x + acc end)
    |> abs
  end
  def codify(_) do
    0
  end

  @spec format_date(Ecto.Date.type | Ecto.DateTime.type, String.t, atom | nil) :: String.t | no_return
  def format_date(date, format_string, formatter \\ Timex.Format.DateTime.Formatters.Default)
  def format_date(%Ecto.Date{} = date, format_string, formatter) do
    date
    |> Ecto.Date.to_erl
    |> Timex.format!(format_string, formatter)
  end
  def format_date(%Ecto.DateTime{} = datetime, format_string, formatter) do
    datetime
    |> Ecto.DateTime.to_erl
    |> Timex.format!(format_string, formatter)
  end
end
