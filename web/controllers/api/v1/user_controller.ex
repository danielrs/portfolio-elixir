defmodule Portfolio.UserController do
  use Portfolio.Web, :controller

  alias Portfolio.User
  require Logger

  plug :authorize_creation when action in [:create]
  plug :authorize_modification when action in [:update, :delete]
  plug :scrub_params, "user" when action in [:create, :update]

  def index(conn, _params) do
    users = User |> Ecto.Query.preload(:role) |> Repo.all
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user |> Repo.preload(:role))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User |> Ecto.Query.preload(:role), id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user |> Repo.preload(:role))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete!(user)
    send_resp(conn, :no_content, "")
  end

  defp authorize_creation(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    if user && user.role.admin? do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Portfolio.SessionView, "forbidden.json", error: "You are not authorized to create new users!")
      |> halt
    end
  end

  defp authorize_modification(conn, _opts) do
    %{"id" => id} = conn.params
    user = Guardian.Plug.current_resource(conn)
    if user && (user.role.admin? or user.id == id) do
      conn
    else
      conn
      |> put_status(:forbidden)
      |> render(Portfolio.SessionView, "forbidden.json", error: "You are not authorized to modify that user!")
      |> halt
    end
  end
end
