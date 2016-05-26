defmodule Portfolio.Utils do

  @spec oneOf([any], any) :: bool
  def oneOf(list, value) do
    Enum.any? list, fn x ->
      x == value
    end
  end
end
