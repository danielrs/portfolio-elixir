defmodule Portfolio.HomeController do
  use Portfolio.Web, :controller
  alias Ecto.Query
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.Post

  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    user = Repo.get_by(User, email: Application.get_env(:portfolio, :showcase_email))
    projects = (from p in Project.query_projects, where: p.user_id == ^user.id)
               |> Project.filter_by(%{order_by: "-date"})
               |> Repo.all

    render conn, "index.html", page_title: page_title, projects: projects, posts: latest_posts
  end

  defp latest_posts do
    Post.query_posts
    |> Query.where(published?: true)
    |> Ecto.Query.order_by(desc: :date, desc: :inserted_at, asc: :title)
    |> Ecto.Query.limit(4)
    |> Repo.all
  end
end
