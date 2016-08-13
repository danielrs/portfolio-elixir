defmodule Portfolio.PostControllerTest do
  use Portfolio.ConnCase

  alias Portfolio.Factory
  alias Portfolio.Post

  setup %{conn: conn} do
    nonadmin_role = Factory.insert(:role)
    admin_role    = Factory.insert(:role, admin?: true)
    nonadmin_user = Factory.insert(:user, role: nonadmin_role)
    admin_user    = Factory.insert(:user, role: admin_role)

    {:ok, nonadmin_conn} = login_user(conn, nonadmin_user)
    {:ok, admin_conn} = login_user(conn, admin_user)

    {:ok,
     conn: conn,
     nonadmin_conn: nonadmin_conn,
     admin_conn: admin_conn,
     nonadmin_user: nonadmin_user,
     admin_user: admin_user}
  end

  test "lists all entries on index", %{nonadmin_conn: conn, nonadmin_user: user} do
    Factory.insert(:post, user: user)
    conn = get conn, user_post_path(conn, :index, user)
    assert json_response(conn, 200)["data"] != []
  end

  test "shows chosen resource", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = get conn, user_post_path(conn, :show, user, post)
    assert json_response(conn, 200)["data"] == %{"id" => post.id,
      "title" => post.title,
      "slug" => post.slug,
      "markdown" => post.markdown,
      "html" => post.html,
      "date" => Ecto.Date.to_string(post.date),
      "published" => post.published,
      "user_id" => post.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{nonadmin_conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_post_path(conn, :show, -1, -1)
    end
  end

  test "creates and renders resource when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    post_params = Factory.params_for_2(:post)
    conn = post conn, user_post_path(conn, :create, user), post: post_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not create resource and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    conn = post conn, user_post_path(conn, :create, user), post: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag admin: true
  test "creates and renders resource from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    post_params = Factory.params_for_2(:post, user: user)
    conn = post conn, user_post_path(conn, :create, user), post: post_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not create and renders resource for another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    post_params = Factory.params_for_2(:post, user: user)
    conn = post conn, user_post_path(conn, :create, user), post: post_params
    assert json_response(conn, 403)["error"]
  end

  test "updates and renders chosen resource when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for_2(:post)
    conn = patch conn, user_post_path(conn, :update, user, post), post: post_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = patch conn, user_post_path(conn, :update, user, post), post: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag admin: true
  test "updates and renders chosen resource from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for_2(:post)
    conn = patch conn, user_post_path(conn, :update, user, post), post: post_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not update chosen resource from another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for_2(:post)
    conn = patch conn, user_post_path(conn, :update, user, post), post: post_params
    assert json_response(conn, 403)["error"]
  end

  test "deletes chosen resource", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert response(conn, 204)
    refute Repo.get(Post, post.id)
  end

  @tag admin: true
  test "deletes chosen resource from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert response(conn, 204)
    refute Repo.get(Post, post.id)
  end

  test "does not delete chosen resource from another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert json_response(conn, 403)["error"]
  end
end
