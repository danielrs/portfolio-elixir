defmodule Portfolio.BlogControllerTest do
  use PortfolioWeb.ConnCase
  alias Portfolio.Factory

  setup %{conn: conn} do
    conn |> setup_conn
  end

  test "index doesn't show body", %{conn: conn} do
    post = Factory.insert(:post)
    conn = get conn, blog_path(conn, :index)
    refute html_response(conn, 200) =~ post.html
  end

  test "showing an unpublished post shows not found", %{conn: conn} do
    post = Factory.insert(:post, published?: false)
    assert_error_sent 404, fn ->
      get conn, blog_path(conn, :show, post.id, post.slug)
    end
  end

  test "showing a published post by id redirects to correct id and slug", %{conn: conn} do
    post = Factory.insert(:post)
    conn = get conn, blog_path(conn, :show_proxy, post.id)
    assert redirected_to(conn) =~ blog_path(conn, :show, post.id, post.slug)
  end

  test "showing a published post with id and wrong slug redirects to correct slug", %{conn: conn} do
    post = Factory.insert(:post)
    conn = get conn, blog_path(conn, :show, post.id, "incorrect-slug")
    assert redirected_to(conn) =~ blog_path(conn, :show, post.id, post.slug)
  end

  test "shows a published post when id and slug are valid", %{conn: conn} do
    post = Factory.insert(:post)
    conn = get conn, blog_path(conn, :show, post.id, post.slug)
    assert html_response(conn, 200) =~ post.title
    assert html_response(conn, 200) =~ post.html
  end

  test "shows author name and body when displaying a post", %{conn: conn} do
    post = Factory.insert(:post)
    conn = get conn, blog_path(conn, :show, post.id, post.slug)
    assert html_response(conn, 200) =~ post.user.first_name <> " " <> post.user.last_name
    assert html_response(conn, 200) =~ post.html
  end

  test "doesn't show any tags when post doesn't has any tags", %{conn: conn} do
    post = Factory.insert(:post, tags: [])
    conn = get conn, blog_path(conn, :show, post.id, post.slug)
    refute html_response(conn, 200) =~ "post__tags"
  end

  test "show tags when post has tags", %{conn: conn} do
    post = Factory.insert(:post_with_tags)
    conn = get conn, blog_path(conn, :show, post.id, post.slug)
    assert html_response(conn, 200) =~ "post__tags"
  end
end
