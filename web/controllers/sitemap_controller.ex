defmodule Portfolio.SitemapController do
  use Portfolio.Web, :controller

  alias Portfolio.Post

  plug :put_layout, :none

  def sitemap(conn, _params) do
    posts = query_posts |> Repo.all
    tags = query_tags |> Repo.all

    conn
    |> put_resp_content_type("text/xml")
    |> render("sitemap.xml", posts: posts, tags: tags)
  end

  defp query_posts do
    Post.query_posts
    |> Ecto.Query.where(published?: true)
    |> Ecto.Query.order_by(desc: :date, desc: :inserted_at, asc: :title)
  end

  defp query_tags do
    Portfolio.Tag
    |> Ecto.Query.order_by(asc: :name)
  end
end
