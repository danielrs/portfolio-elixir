defmodule Portfolio.Utils do

  @spec oneOf([any], any) :: boolean
  def oneOf(list, value) do
    Enum.any? list, fn x ->
      x == value
    end
  end

  @spec codify(Strint.t) :: integer
  def codify(string) do
    string
    |> to_char_list
    |> Enum.reduce(fn (x, acc) -> x + acc end)
    |> abs
  end
end
