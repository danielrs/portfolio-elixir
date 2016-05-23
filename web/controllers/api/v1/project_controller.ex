defmodule Portfolio.ProjectController do
  use Portfolio.Web, :controller

  alias Portfolio.Project
  require Logger

  plug Portfolio.Plug.Filter, Project when action in [:index]
  plug :scrub_params, "project" when action in [:create, :update]

  def index(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    projects = assoc(user, :projects) |> Project.order_by(params) |> Project.search_by(params) |> Repo.all
    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"project" => project_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = user |> build_assoc(:projects) |> Project.changeset(project_params)

    case Repo.insert(changeset) do
      {:ok, project} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", project_path(conn, :show, project))
        |> render("show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    project = Repo.get!(Project, id, user_id: user.id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"id" => id, "project" => project_params}) do
    user = Guardian.Plug.current_resource(conn)
    project = Repo.get!(Project, id, user_id: user.id) |> Map.take([:id, :user_id])
    changeset = Project.changeset(struct(Project, project), project_params)

    case Repo.update(changeset) do
      {:ok, project} ->
        render(conn, "show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    project = Repo.get!(Project, id, user_id: user.id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(project)

    send_resp(conn, :no_content, "")
  end
end
