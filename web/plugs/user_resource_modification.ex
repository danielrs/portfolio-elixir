defmodule Portfolio.Plug.UserResourceModification do
  @moduledoc """
  This plug authorizes modification of an existing user's resources
  """
  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    %{"user_id" => resource_user_id} = conn.params
    if user && (user.role.admin? or resource_user_id == Integer.to_string(user.id)) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(
        Portfolio.SessionView,
        "forbidden.json",
        error: "You are not authorized to modify resources for this user")
      |> halt
    end
  end
end
