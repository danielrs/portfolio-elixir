defmodule Portfolio.HomeController do
  use Portfolio.Web, :controller
  alias Ecto.Query
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.Post
  alias Portfolio.Paginator

  plug Portfolio.Plug.Menu

  def index(conn, params) do
    user = Repo.get_by(User, email: Application.get_env(:portfolio, :showcase_email))
    projects = user && assoc(user, :projects) |> Project.filter_by(params) |> Repo.all || []
    render conn, "index.html", page_title: "Daniel Rivas", projects: projects, posts: latest_posts
  end

  defp latest_posts do
    Post
    |> Query.preload(:user)
    |> Query.select([:id, :title, :slug, :date, :published?, :user_id])
    |> Query.where(published?: true)
    |> Ecto.Query.order_by(desc: :date)
    |> Ecto.Query.limit(4)
    |> Repo.all
  end
end
