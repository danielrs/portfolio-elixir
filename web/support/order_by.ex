defmodule Portfolio.OrderBy do
  @type order :: :desc | :asc

  @spec from_string(String.t, [String.t]) :: [{order, String.t}]
  def from_string(string, valid_fields) do
    string
    |> tokenize
    |> Enum.filter(fn {_, field} -> contains(valid_fields, field) end)
    |> Enum.map(fn {order, field} -> {order, String.to_atom(field)} end)
  end

  @spec tokenize(String.t) :: [{order, String.t}]
  defp tokenize(string) do
    string
    |> String.split(~r/,/u)
    |> Enum.map(fn x -> decode_field(x) end)
  end

  @spec decode_field(String.t) :: {order, String.t}
  defp decode_field("+" <> field), do: {:asc, field}
  defp decode_field("-" <> field), do: {:desc, field}
  defp decode_field(field), do: {:desc, field}

  defp contains(enum, item) do
    Enum.any?(enum, fn x -> x == item end)
  end
end
