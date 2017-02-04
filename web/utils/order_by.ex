defmodule Portfolio.OrderBy do
  @moduledoc """
  This module contains functions for parsing query strings such as:

  `-field1,+field2`

  Into a list of tuples for easy handling:

  `[{:desc, "field1"}, {:asc, "field2"}]`
  """

  @type order :: :desc | :asc

  @spec from_string(String.t, [String.t]) :: [{order, String.t}]
  def from_string(string, valid_fields) do
    string
    |> tokenize
    |> Enum.filter(fn {_, field} -> Enum.member?(valid_fields, field) end)
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
end
