defmodule Portfolio.Plug.RequestPath do
  @moduledoc false
  import Plug.Conn

  def init(opts), do: opts

  def call(%{:request_path => request_path} = conn, _opts) do
    conn
    |> assign(:request_path, request_path)
  end
end
