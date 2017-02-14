defmodule Portfolio.BlogController do
  use Portfolio.Web, :controller
  alias Ecto.Query
  alias Portfolio.Post

  plug Portfolio.Plug.Menu
  plug :fix_slug when action in [:show_proxy, :show]

  def index(conn, params) do
    paginator = query_posts(params) |> paginate_posts(params)
    render conn, "index.html", page_title: page_title("Blog"), paginator: paginator
  end

  def show_proxy(conn, _params) do
    conn
  end

  def show(conn, %{"id" => id}) do
    post = query_posts(%{}) |> Repo.get!(id)
    if post.published? do
      render(conn, "show.html", page_title: page_title(post.title), post: post)
    else
      conn
      |> put_flash(:info, "You are not allowed to view unpublished posts")
      |> redirect(to: blog_path(conn, :index))
    end
  end

  defp fix_slug(conn, _opts) do
    post = Post |> Repo.get!(conn.params["id"])
    if post && post.slug != conn.params["slug"] do
      conn
      |> redirect(to: blog_path(conn, :show, post.id, post.slug))
      |> halt
    else
      conn
    end
  end

  defp query_posts(params) do
    if tag_name = Map.get(params, "tag") do
      from [_, _, _, t] in Post.query_posts,
        where: t.name == ^tag_name
    else
      Post.query_posts
    end
  end

  defp paginate_posts(query, params) do
    query
    |> Query.where(published?: true)
    |> Query.order_by(desc: :date, desc: :inserted_at, asc: :title)
    |> Repo.paginate(params)
  end
end
