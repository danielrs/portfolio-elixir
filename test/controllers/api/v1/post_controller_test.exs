defmodule Portfolio.PostControllerTest do
  use Portfolio.ConnCase

  alias Portfolio.TestData
  alias Portfolio.Post

  @valid_attrs %{title: "some content", slug: "some-content", markdown: "some content", html: "<p>some content</p>\n", published: true, date: Ecto.Date.utc}
  @invalid_attrs %{}

  setup %{conn: conn} do
    TestData.insert_roles
    TestData.insert_users
    auth_response = post conn, session_path(conn, :create) , [session: TestData.user]
    %{"data" => %{"jwt" => jwt, "user" => %{"id" => user_id}}} = auth_response.resp_body |> Poison.decode!
    new_conn = conn
               |> put_req_header("accept", "application/json")
               |> put_req_header("authorization", jwt)
    {:ok, conn: new_conn, user_id: user_id}
  end

  test "lists all entries on index before inserting", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all entries on index after inserting", %{conn: conn} do
    TestData.insert_posts
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] != []
  end

  test "shows chosen resource", %{conn: conn, user_id: user_id} do
    TestData.insert_posts
    [post] = Repo.all(from p in Post, where: p.user_id == ^user_id, limit: 1)
    conn = get conn, post_path(conn, :show, post)
    assert json_response(conn, 200)["data"] == %{"id" => post.id,
      "title" => post.title,
      "slug" => post.slug,
      "markdown" => post.markdown,
      "html" => post.html,
      "date" => Ecto.Date.to_string(post.date),
      "published" => post.published,
      "user_id" => post.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user_id: user_id} do
    post = Repo.insert! post_for_user(user_id)
    conn = put conn, post_path(conn, :update, post), post: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Post, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user_id: user_id} do
    post = Repo.insert! post_for_user(user_id)
    conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user_id: user_id} do
    post = Repo.insert! post_for_user(user_id)
    conn = delete conn, post_path(conn, :delete, post)
    assert response(conn, 204)
    refute Repo.get(Post, post.id)
  end

  defp post_for_user(user_id) do
    params = @valid_attrs |> Map.put(:user_id, user_id)
    struct(Post, params)
  end
end
