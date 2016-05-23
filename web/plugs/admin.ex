defmodule Portfolio.Plug.Admin do
  import Plug.Conn

  def init(default), do: default

  def call(conn, opts) do
    conn |> assign(:admin, true)
  end
end
