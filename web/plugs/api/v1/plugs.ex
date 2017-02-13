defmodule Portfolio.API.V1.Plugs do
  import Plug.Conn
  import Phoenix.Controller

  alias Portfolio.API.V1.SessionView

  @doc """
  This plug ensures that the user is an admin.
  """
  def ensure_admin(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    if user && user.role.admin? do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(SessionView, "forbidden.json", error: "Only admins can do this action")
      |> halt
    end
  end

  @doc """
  This plug authorizes modification of an existing user's resources.
  """
  def ensure_admin_or_owner(conn, _opts) do
    user = Guardian.Plug.current_resource(conn)
    %{"user_id" => resource_user_id} = conn.params
    if user && (user.role.admin? or resource_user_id == Integer.to_string(user.id)) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(
        SessionView,
        "forbidden.json",
        error: "You are not authorized to modify resources for this user")
      |> halt
    end
  end

  @doc """
  This Plug ensures that an user has been loaded by Guardian's LoadResource Plug, otherwise it returns forbidden status.
  """
  def ensure_guardian_resource_loaded(conn, _opts) do
    if Guardian.Plug.current_resource(conn) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(SessionView, "forbidden.json", error: "Invalid user")
      |> halt
    end
  end
end
