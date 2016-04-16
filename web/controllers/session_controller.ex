defmodule Portfolio.SessionController do
  use Portfolio.Web, :controller
  alias Portfolio.Login

  plug :put_layout, "login.html"
  plug :scrub_params, "login" when action in [:create]
  plug Portfolio.Plug.PageTitle, title: "Login - Daniel Rivas"
  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    changeset = Login.changeset(%Login{request_path: get_flash(conn, :request_path)})
    render(conn, "index.html", changeset: changeset)
  end

  def create(conn, %{"login" => login_params}) do
    changeset = Login.changeset(%Login{}, login_params)
    case Login.confirm_credentials(changeset) do
      {:ok, user} ->
        target = changeset.changes[:request_path] || admin_home_path(conn, :index)
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(external: target)
      {:error, changeset} ->
        render(conn, "index.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: session_path(conn, :index))
  end

  def unauthenticated(%{request_path: request_path} = conn, _params) do
    conn
    |> put_flash(:info, "Authentication required")
    |> put_flash(:request_path, request_path)
    |> redirect(to: session_path(conn, :index))
  end
end
