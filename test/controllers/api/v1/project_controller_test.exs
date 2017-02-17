defmodule Portfolio.API.V1.ProjectControllerTest do
  use Portfolio.ConnCase

  alias Portfolio.Factory
  alias Portfolio.Project

  setup %{conn: conn} do
    conn |> setup_conn
  end

  test "lists all entries on index", %{nonadmin_conn: conn, nonadmin_user: user} do
    Factory.insert(:project, user: user)
    conn = get conn, user_project_path(conn, :index, user)
    assert json_response(conn, 200)["data"] != []
  end

  test "shows chosen resource", %{nonadmin_conn: conn, nonadmin_user: user} do
    tags = Factory.insert_list(3, :tag)
    project = Factory.insert(:project, user: user, tags: tags)
    tags = tags |> Enum.map(fn tag ->
      for {key, val} <- (tag |> Map.from_struct |> Map.take([:id, :name])),
        into: %{},
        do: {Atom.to_string(key), val}
    end)

    conn = get conn, user_project_path(conn, :show, user, project)
    assert json_response(conn, 200)["data"] == %{"id" => project.id,
      "title" => project.title,
      "description" => project.description,
      "homepage" => project.homepage,
      "content" => project.content,
      "date" => Ecto.Date.to_string(project.date),
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

  test "does not show resource and instead throw error when id is nonexistent", %{nonadmin_conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_project_path(conn, :show, -1, -1)
    end
  end

  test "creates and renders resource when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project_params = Factory.params_for_2(:project)
    conn = post conn, user_project_path(conn, :create, user), project: project_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Project, project_params)
  end

  test "does not create resource and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    conn = post conn, user_project_path(conn, :create, user), project: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag admin: true
  test "creates and renders resource for another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    project_params = Factory.params_for_2(:project, user: user)
    conn = post conn, user_project_path(conn, :create, user), project: project_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Project, project_params)
  end

  test "does not create and renders resource for another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    project_params = Factory.params_for_2(:project, user: user)
    conn = post conn, user_project_path(conn, :create, user), project: project_params
    assert json_response(conn, 403)["error"]
  end

  test "creates and renders project with no tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    project_params = Factory.params_for(:project)
    conn = post conn, user_project_path(conn, :create, user), project: project_params

    assert json_response(conn, 201)["data"]["id"]
    assert length(json_response(conn, 201)["data"]["tags"]) == 0
  end

  test "updates and renders chosen resource when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    project_params = Factory.params_for_2(:project)
    conn = patch conn, user_project_path(conn, :update, user, project), project: project_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Project, project_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    conn = patch conn, user_project_path(conn, :update, user, project), project: %{title: ""}
    assert json_response(conn, 422)["errors"] != %{}
  end

  @tag admin: true
  test "updates and renders chosen resource from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    project_params = Factory.params_for_2(:project)
    conn = patch conn, user_project_path(conn, :update, user, project), project: project_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Project, project_params)
  end

  test "does not update chosen resource from another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    project = Factory.insert(:project, user: user)
    project_params = Factory.params_for_2(:project)
    conn = patch conn, user_project_path(conn, :update, user, project), project: project_params
    assert json_response(conn, 403)["error"]
  end

  test "updates and sets project tags to no tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    project_params = Factory.params_for(:project)
    conn = patch conn, user_project_path(conn, :update, user, project), project: project_params

    assert json_response(conn, 200)["data"]["id"]
    assert length(json_response(conn, 200)["data"]["tags"]) == 0
  end

  test "updates and sets project tags to new tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    tags = Factory.build_list(3, :tag) |> Enum.map(& &1 |> Map.get(:name))
    project = Factory.insert(:project, user: user)
    project_params = Factory.params_for(:project)

    conn = patch conn, user_project_path(conn, :update, user, project),
    project: project_params, tags: tags

    assert json_response(conn, 200)["data"]["id"]
    assert length(json_response(conn, 200)["data"]["tags"]) == 3
  end

  test "updates and sets project without tags to new tags", %{nonadmin_conn: conn, nonadmin_user: user} do
    tags = Factory.build_list(3, :tag) |> Enum.map(& &1 |> Map.get(:name))
    project = Factory.insert(:project, user: user, tags: [])
    project_params = Factory.params_for(:project)

    conn = patch conn, user_project_path(conn, :update, user, project),
    project: project_params, tags: tags

    assert json_response(conn, 200)["data"]["id"]
    assert length(json_response(conn, 200)["data"]["tags"]) == 3
  end

  test "deletes chosen resource", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    conn = delete conn, user_project_path(conn, :delete, user, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end

  @tag admin: true
  test "deletes chosen resource from another user as admin", %{admin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    conn = delete conn, user_project_path(conn, :delete, user, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end

  test "does not delete chosen resource from another user as non-admin user", %{nonadmin_conn: conn, admin_user: user} do
    project = Factory.insert(:project, user: user)
    conn = delete conn, user_project_path(conn, :delete, user, project)
    assert response(conn, 403)
  end
end
