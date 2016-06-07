defmodule Portfolio.SetupController do
  use Portfolio.Web, :controller

  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User

  require Logger

  plug :scrub_params, "user" when action in [:create]
  plug :put_layout, "setup.html"

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "index.html", page_title: "Setup", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    role = Repo.get_by!(Role, name: "admin", admin?: true)
    changeset = User.changeset(%User{role_id: role.id}, user_params)

    Logger.debug inspect(changeset.errors)
    case Repo.insert(changeset) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Setup completed successfully")
        |> redirect(to: home_path(conn, :index))
      {:error, changeset} ->
        render conn, "index.html", page_title: "Setup", changeset: changeset
    end
  end
end
