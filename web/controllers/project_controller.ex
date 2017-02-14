defmodule Portfolio.ProjectController do
  use Portfolio.Web, :controller
  alias Portfolio.User
  alias Portfolio.Project

  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    user = Repo.get_by(User, email: Application.get_env(:portfolio, :showcase_email))
    projects = (from p in Project.query_projects, where: p.user_id == ^user.id)
               |> Project.filter_by(%{order_by: "-date"})
               |> Repo.all

    render conn, "index.html", page_title: page_title("Projects"), projects: projects
  end
end
