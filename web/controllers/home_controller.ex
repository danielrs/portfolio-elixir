defmodule Portfolio.HomeController do
  use Portfolio.Web, :controller
  alias Portfolio.User
  alias Portfolio.Project

  plug Portfolio.Plug.Menu

  def index(conn, params) do
    user = Repo.get_by(User, email: Application.get_env(:portfolio, :showcase_email))
    projects = user && assoc(user, :projects) |> Project.filter_by(params) |> Repo.all || []
    render conn, "index.html", page_title: "Daniel Rivas", projects: projects
  end
end
