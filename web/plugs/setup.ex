defmodule Portfolio.Plug.Setup do
  import Plug.Conn
  import Phoenix.Controller

  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User

  require Ecto.Query

  def ensure_setup(conn, _opts) do
    if theres_admins? do
      conn
    else
      conn
      |> redirect(to: "/setup")
      |> halt
    end
  end

  def ensure_not_setup(conn, _opts) do
    if not theres_admins? do
      conn
    else
      conn
      |> redirect(to: "/")
      |> halt
    end
  end

  defp theres_admins? do
    (Role |> Ecto.Query.where(admin?: true) |> Repo.one)
    |> Ecto.assoc(:users)
    |> Repo.one
    |> is_nil
    |> Kernel.not
  end
end
