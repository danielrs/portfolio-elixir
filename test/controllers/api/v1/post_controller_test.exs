defmodule Portfolio.API.V1.PostControllerTest do
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

  test "shows chosen post", %{nonadmin_conn: conn, nonadmin_user: user} do
    tags = Factory.insert_list(3, :tag)
    post = Factory.insert(:post, user: user, tags: tags)
    tags = tags |> Enum.map(fn tag ->
      for {key, val} <- (tag |> Map.from_struct |> Map.take([:id, :name])),
        into: %{},
        do: {Atom.to_string(key), val}
    end)

    conn = get conn, user_post_path(conn, :show, user, post)
    assert json_response(conn, 200)["data"] == %{"id" => post.id,
      "title" => post.title,
      "slug" => post.slug,
      "markdown" => post.markdown,
      "html" => post.html,
      "date" => Ecto.Date.to_string(post.date),
      "published?" => post.published?,
      "user" => %{
        "id" => user.id,
        "email" => user.email,
        "first_name" => user.first_name,
        "last_name" => user.last_name,
        "role" => %{
          "id" => user.role.id,
          "name" => user.role.name,
          "admin?" => user.role.admin?
        }
      },
      "tags" => tags
    }
  end

  test "does not show post and instead throw error when id is nonexistent", %{nonadmin_conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_post_path(conn, :show, -1, -1)
    end
  end

  test "creates and renders post when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    post_params = Factory.params_for_2(:post)
    conn = post conn, user_post_path(conn, :create, user), post: post_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not create post and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    conn = post conn, user_post_path(conn, :create, user), post: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag admin: true
  test "creates and renders post from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    post_params = Factory.params_for_2(:post, user: user)
    conn = post conn, user_post_path(conn, :create, user), post: post_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not create and renders post for another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    post_params = Factory.params_for_2(:post, user: user)
    conn = post conn, user_post_path(conn, :create, user), post: post_params
    assert json_response(conn, 403)["error"]
  end

  test "creates and renders post with no tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    post_params = Factory.params_for(:post)
    conn = post conn, user_post_path(conn, :create, user), post: post_params

    assert json_response(conn, 201)["data"]["id"]
    assert length(json_response(conn, 201)["data"]["tags"]) == 0
  end

  test "updates and renders chosen post when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for_2(:post)
    conn = patch conn, user_post_path(conn, :update, user, post), post: post_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not update chosen post and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = patch conn, user_post_path(conn, :update, user, post), post: %{title: ""}
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag admin: true
  test "updates and renders chosen post from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for_2(:post)
    conn = patch conn, user_post_path(conn, :update, user, post), post: post_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Post, post_params)
  end

  test "does not update chosen post from another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for_2(:post)
    conn = patch conn, user_post_path(conn, :update, user, post), post: post_params
    assert json_response(conn, 403)["error"]
  end

  test "updates and sets post tags to no tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for(:post)
    conn = patch conn, user_post_path(conn, :update, user, post), post: post_params

    assert json_response(conn, 200)["data"]["id"]
    assert length(json_response(conn, 200)["data"]["tags"]) == 0
  end

  test "updates and sets post tags to new tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    tags = Factory.build_list(3, :tag) |> Enum.map(& &1 |> Map.get(:name))
    post = Factory.insert(:post, user: user)
    post_params = Factory.params_for(:post)

    conn = patch conn, user_post_path(conn, :update, user, post),
    post: post_params, tags: tags

    assert json_response(conn, 200)["data"]["id"]
    assert length(json_response(conn, 200)["data"]["tags"]) == 3
  end

  test "updates and sets post without tags to new tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    tags = Factory.build_list(3, :tag) |> Enum.map(& &1 |> Map.get(:name))
    post = Factory.insert(:post, user: user, tags: [])
    post_params = Factory.params_for(:post)

    conn = patch conn, user_post_path(conn, :update, user, post),
    post: post_params, tags: tags

    assert json_response(conn, 200)["data"]["id"]
    assert length(json_response(conn, 200)["data"]["tags"]) == 3
  end

  test "deletes chosen post", %{nonadmin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert response(conn, 204)
    refute Repo.get(Post, post.id)
  end

  @tag admin: true
  test "deletes chosen post from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert response(conn, 204)
    refute Repo.get(Post, post.id)
  end

  test "does not delete chosen post from another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    post = Factory.insert(:post, user: user)
    conn = delete conn, user_post_path(conn, :delete, user, post)
    assert json_response(conn, 403)["error"]
  end
end
