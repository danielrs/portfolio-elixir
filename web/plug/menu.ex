defmodule Portfolio.Plug.Menu do
  @moduledoc false

  import Portfolio.Router.Helpers
  import Plug.Conn

  def path_root(path) do
    path |> split_path |> hd_or("")
  end

  defp split_path(path) do
    segments = :binary.split(path, "/", [:global])
    for segment <- segments, segment != "", do: segment
  end

  defp hd_or(list, default) do
    try do
      hd list
    rescue
      ArgumentError -> default
    end
  end

  defmacrop menu_entry(caption, path_func) do
    quote do
      %{caption: unquote(caption),
        path: unquote(path_func)(Portfolio.Endpoint, :index),
        root: unquote(path_func)(Portfolio.Endpoint, :index) |> path_root}
    end
  end

  def init(opts) do
    menu = [menu_entry("Home", :home_path),
            menu_entry("Projects", :projects_path),
            menu_entry("Contact", :contact_path),
            menu_entry("Blog", :blog_path)]

    Keyword.put(opts, :menu, menu);
  end

  def call(%{:path_info => path_info} = conn, opts) do
    conn
    |> assign(:menu, Keyword.get(opts, :menu))
    |> assign(:menu_root, hd_or(path_info, ""))
  end
end
