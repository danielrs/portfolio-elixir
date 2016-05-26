defmodule Portfolio.Plug.EnsureAdmin do
  @moduledoc """
  This Plug ensures that the loaded user is an admin
  """
  use Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    if user.admin? do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Portfolio.SessionView, "forbidden.json", error: "User not an admin")
      |> halt
    end
  end
end
