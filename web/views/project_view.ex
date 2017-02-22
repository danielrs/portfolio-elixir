defmodule Portfolio.ProjectView do
  use Portfolio.Web, :view
  alias Portfolio.Utils

  def band_class(string) do
    "project-card__band--color-"
    <> (Utils.codify(string) |> rem(10) |> Integer.to_string)
  end
end
