defmodule Portfolio.API.V1.ProjectController do
  use Portfolio.Web, :controller

  import API.V1.Plugs

  alias Portfolio.User
  alias Portfolio.Project

  alias Portfolio.TagUpdater

  plug :ensure_admin_or_owner when action in [:create, :update, :delete]

  def index(conn, %{"user_id" => user_id} = params) do
    projects = (from p in Project.query_projects, where: p.user_id == ^user_id)
               |> Project.filter_by(params)
               |> Repo.all

    render(conn, "index.json", projects: projects)
  end

  def create(conn, %{"user_id" => user_id, "project" => project_params} = params) do
    user = Repo.get!(User, user_id)
    changeset = user |> build_assoc(:projects) |> Project.changeset(project_params)
                |> TagUpdater.put_tags(params["tags"])

    case Repo.insert(changeset) do
      {:ok, project} ->
        project = Project.query_projects |> Repo.get_by!(id: project.id, user_id: user_id)

        conn
        |> put_status(:created)
        |> put_resp_header("location", user_project_path(conn, :show, user, project))
        |> render("show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    project = Project.query_projects |> Repo.get_by!(id: id, user_id: user_id)
    render(conn, "show.json", project: project)
  end

  def update(conn, %{"user_id" => user_id, "id" => id, "project" => project_params} = params) do
    project = Project.query_projects |> Repo.get_by!(id: id, user_id: user_id)
    changeset = Project.changeset(project, project_params)
                |> TagUpdater.put_tags(params["tags"])

    case Repo.update(changeset) do
      {:ok, project} ->
        project = Project.query_projects |> Repo.get_by!(id: project.id, user_id: user_id)

        render(conn, "show.json", project: project)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    project = Repo.get!(Project, id, user_id: user_id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(project)

    send_resp(conn, :no_content, "")
  end
end
