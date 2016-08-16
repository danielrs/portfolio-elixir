defmodule Portfolio.HomeController do
  use Portfolio.Web, :controller
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.Post

  plug Portfolio.Plug.Menu

  def index(conn, params) do
    user = Repo.get_by(User, email: Application.get_env(:portfolio, :showcase_email))
    projects = user && assoc(user, :projects) |> Project.filter_by(params) |> Repo.all || []
    posts = Post |> Ecto.Query.order_by(desc: :date) |> Ecto.Query.limit(4) |> Repo.all
    render conn, "index.html", page_title: "Daniel Rivas", projects: projects, posts: posts
  end
end
