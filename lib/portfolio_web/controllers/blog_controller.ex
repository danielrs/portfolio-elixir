defmodule PortfolioWeb.BlogController do
  use PortfolioWeb, :controller
  alias Ecto.Query
  alias Portfolio.Post
  alias Portfolio.BlogFilter

  plug Portfolio.Plug.Menu
  plug :fix_slug when action in [:show_proxy, :show]

  def index(conn, params) do
    paginator = BlogFilter.query_posts(params)
                |> paginate_posts(params)
                |> drop_body

    conn
    |> SEO.put_title("Blog")
    |> SEO.put_meta("Daniel Rivas programming blog")
    |> render("index.html", paginator: paginator)
  end

  def show_proxy(conn, _params) do
    conn
  end

  def show(conn, %{"id" => id}) do
    post = Post.query_posts |> Repo.get_by!(id: id, published?: true)

    conn
    |> SEO.put_title(post.title)
    |> SEO.put_meta(post.description)
    |> render("show.html", post: post)
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

  defp paginate_posts(query, params) do
    query
    |> Query.where(published?: true)
    |> Query.order_by(desc: :date, desc: :inserted_at, asc: :title)
    |> Repo.paginate(params)
  end

  defp drop_body(paginator) do
    %{paginator | entries: Enum.map(paginator.entries, fn entry ->
      entry |> Map.drop([:markdown, :html])
    end)}
  end
end
