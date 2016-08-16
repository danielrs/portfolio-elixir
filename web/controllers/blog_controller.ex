defmodule Portfolio.BlogController do
  use Portfolio.Web, :controller
  alias Portfolio.Post

  plug Portfolio.Plug.Menu
  plug :fix_slug when action in [:show_proxy, :show]

  def index(conn, _params) do
    posts = Post |> Ecto.Query.preload(:user) |> Ecto.Query.order_by(desc: :date) |> Repo.all
    render conn, "index.html", page_title: "Blog - Daniel Rivas", posts: posts
  end

  def show_proxy(conn, %{"id" => id}) do
    conn
  end

  def show(conn, %{"id" => id}) do
    post = Post |> Ecto.Query.preload(:user) |> Repo.get!(id)
    render(conn, "show.html", post: post)
  end

  defp fix_slug(conn, _opts) do
    post = Post |> Repo.get!(conn.params["id"])
    if post && post.slug != conn.params["slug"] do
      conn
      |> redirect(to: blog_path(conn, :show, post.id, post.slug))
    else
      conn
    end
  end
end
