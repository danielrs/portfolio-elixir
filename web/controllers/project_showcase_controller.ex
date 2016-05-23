defmodule Portfolio.ProjectShowcaseController do
  use Portfolio.Web, :controller
  alias Portfolio.User
  alias Portfolio.Project

  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    user = Repo.get_by(User, email: "ers.daniel@gmail.com")
    projects = user && assoc(user, :projects) |> Project.order_by(%{sort_by: "date", order: "desc"}) |> Repo.all
    render conn, "index.html", page_title: "Projects - Daniel Rivas", projects: projects
  end
end
