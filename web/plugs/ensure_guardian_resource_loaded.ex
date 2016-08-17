defmodule Portfolio.Plug.EnsureGuardianResourceLoaded do
  @moduledoc """
  This Plug ensures that an user has been loaded by Guardian's LoadResource Plug, otherwise it returns
  forbidden status
  """
  use Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Portfolio.SessionView, "forbidden.json", error: "Invalid user")
      |> halt
    end
  end
end
