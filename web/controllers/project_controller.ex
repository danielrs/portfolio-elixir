defmodule Portfolio.ProjectController do
  use Portfolio.Web, :controller
  alias Portfolio.User
  alias Portfolio.Project

  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    user = Repo.get_by!(User, email: Application.get_env(:portfolio, :showcase_email))
    projects = (from p in Project.query_projects, where: p.user_id == ^user.id)
               |> Project.filter_by(%{order_by: "-date"})
               |> Repo.all

    conn
    |> SEO.put_title("Projects")
    |> SEO.put_meta("Daniel Rivas personal programming projects")
    |> render("index.html", projects: projects)
  end
end
