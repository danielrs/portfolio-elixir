# Check: https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1
defmodule Portfolio.LayoutView do
  use Portfolio.Web, :view
  import Portfolio.Plug.Menu, only: [path_root: 1]

  @doc """
  Generates the name of the javascript view we want to use for
  this view / template.
  """
  def js_view_name(view_module, view_template) do
    [view_name(view_module), template_name(view_template)]
    |> Enum.reverse
    |> List.insert_at(0, "view")
    |> Enum.map(&String.capitalize/1)
    |> Enum.reverse
    |> Enum.join("")
  end

  # Takes the resource name of the view module and
  # removes the trailing "_view".
  defp view_name(module) do
    module
    |> Phoenix.Naming.resource_name
    |> String.replace("_view", "")
  end

  # Removes the extension from the template and
  # returns just the name.
  defp template_name(template) when is_binary(template) do
    template
    |> String.split(".")
    |> Enum.at(0)
  end
end
