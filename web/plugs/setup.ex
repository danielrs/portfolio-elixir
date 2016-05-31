defmodule Portfolio.Plug.Setup do
  import Plug.Conn
  import Phoenix.Controller, only: [redirect: 2]
  import Ecto.Query, only: [from: 1, from: 2]

  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User


  def ensure_setup(conn, _opts) do
    if theres_admin? do
      conn
    else
      conn
      |> redirect(to: "/setup")
      |> halt
    end
  end

  def ensure_not_setup(conn, _opts) do
    if not theres_admin? do
      conn
    else
      conn
      |> redirect(to: "/")
      |> halt
    end
  end

  defp theres_admin? do
    (from r in Role,
     where: r.admin?,
     join: u in assoc(r, :users), limit: 1)
    |> Repo.one
    |> is_nil
    |> Kernel.not
  end
end
