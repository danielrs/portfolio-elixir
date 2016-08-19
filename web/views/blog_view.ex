defmodule Portfolio.BlogView do
  use Portfolio.Web, :view
  alias Portfolio.Utils

  def tag_class(string) do
    "tag--color-" <> (Utils.codify(string) |> rem(10) |> Integer.to_string)
  end
end
