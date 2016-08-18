defmodule Portfolio.API.V1.ProjectControllerTest do
  use Portfolio.ConnCase

  alias Portfolio.Factory
  alias Portfolio.Project

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
    Factory.insert(:project, user: user)
    conn = get conn, user_project_path(conn, :index, user)
    assert json_response(conn, 200)["data"] != []
  end

  test "shows chosen resource", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    conn = get conn, user_project_path(conn, :show, user, project)
    assert json_response(conn, 200)["data"] == %{"id" => project.id,
      "title" => project.title,
      "description" => project.description,
      "homepage" => project.homepage,
      "content" => project.content,
      "date" => Ecto.Date.to_string(project.date),
      "user_id" => project.user_id}
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

  test "updates and renders chosen resource when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    project_params = Factory.params_for_2(:project)
    conn = patch conn, user_project_path(conn, :update, user, project), project: project_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Project, project_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.insert(:project, user: user)
    conn = patch conn, user_project_path(conn, :update, user, project), project: %{}
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
