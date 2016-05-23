defmodule Portfolio.Plug.PageTitle do
  import Plug.Conn

  def init(default), do: default

  def call(conn, opts) do
    conn |> assign(:page_title, Keyword.get(opts, :title))
  end

end
