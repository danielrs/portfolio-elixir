defmodule Portfolio.ProjectShowcaseController do
  use Portfolio.Web, :controller
  alias Portfolio.User
  alias Portfolio.Project

  plug Portfolio.Plug.PageTitle, title: "Projects - Daniel Rivas"
  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    user = Repo.get_by(User, email: "ers.daniel@gmail.com")
    projects = user && assoc(user, :projects) |> Project.order_by_date |> Repo.all || []

    render conn, "index.html", projects: projects
  end
end
