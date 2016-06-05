defmodule Portfolio.ProjectControllerTest do
  use Portfolio.ConnCase

  alias Portfolio.Factory
  alias Portfolio.Project

  setup %{conn: conn} do
    nonadmin_role = Factory.create(:role)
    admin_role    = Factory.create(:role, admin?: true)
    nonadmin_user = Factory.create(:user, role: nonadmin_role)
    admin_user    = Factory.create(:user, role: admin_role)

    {:ok, nonadmin_conn} = login_user(conn, nonadmin_user)
    {:ok, admin_conn} = login_user(conn, admin_user)

    {:ok, nonadmin_conn: nonadmin_conn, admin_conn: admin_conn, nonadmin_user: nonadmin_user, admin_user: admin_user}
  end

  test "lists all entries on index", %{nonadmin_conn: conn, nonadmin_user: user} do
    Factory.create(:project, user: user)
    conn = get conn, user_project_path(conn, :index, user)
    assert json_response(conn, 200)["data"] != []
  end

  test "shows chosen resource", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.create(:project, user: user)
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

  @tag focus: true
  test "creates and renders resource when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project_params = Factory.params_for(:project)
    conn = post conn, user_project_path(conn, :create, user), project: project_params
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Project, project_params)
  end

  test "does not create resource and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    conn = post conn, user_project_path(conn, :create, user), project: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.create(:project, user: user)
    project_params = Factory.params_for(:project)
    conn = patch conn, user_project_path(conn, :update, user, project), project: project_params
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Project, project_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.create(:project, user: user)
    conn = patch conn, user_project_path(conn, :update, user, project), project: %{}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{nonadmin_conn: conn, nonadmin_user: user} do
    project = Factory.create(:project, user: user)
    conn = delete conn, user_project_path(conn, :delete, user, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end
end
