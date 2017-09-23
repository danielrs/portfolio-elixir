defmodule PortfolioWeb.SetupController do
  use PortfolioWeb, :controller

  alias Portfolio.Seeds
  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User

  plug :put_layout, "setup.html"

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "index.html", title: "Setup", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    Seeds.setup_roles

    role = Repo.get_by!(Role, name: "admin", admin?: true)
    changeset = User.changeset(%User{role_id: role.id}, user_params)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Setup completed successfully")
        |> redirect(to: home_path(conn, :index))
      {:error, changeset} ->
        render conn, "index.html", title: "Setup", changeset: changeset
    end
  end
end
