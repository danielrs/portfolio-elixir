defmodule Portfolio.BlogController do
  use Portfolio.Web, :controller
  alias Ecto.Query
  alias Portfolio.Post
  alias Portfolio.Paginator

  plug Portfolio.Plug.Menu
  plug :fix_slug when action in [:show_proxy, :show]

  def index(conn, params) do
    render conn, "index.html", page_title: "Blog - Daniel Rivas", paginator: post_paginator(params)
  end

  def show_proxy(conn, _params) do
    conn
  end

  def show(conn, %{"id" => id}) do
    post = Post |> Query.preload(:user) |> Query.preload(:tags) |> Repo.get!(id)
    if post.published? do
      render(conn, "show.html", page_title: post.title <> " - Daniel Rivas", post: post)
    else
      conn
      |> put_flash(:info, "You are not allowed to view unpublished posts")
      |> redirect(to: blog_path(conn, :index))
    end
  end

  defp post_paginator(params) do
    Post
    |> Query.preload(:user)
    |> Query.preload(:tags)
    |> Query.select([:id, :title, :slug, :date, :published?, :user_id])
    |> Query.where(published?: true)
    |> Query.order_by(desc: :date)
    |> Paginator.new(params)
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
end
