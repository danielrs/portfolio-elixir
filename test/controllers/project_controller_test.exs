defmodule Portfolio.ProjectControllerTest do
  use Portfolio.ConnCase
  alias Portfolio.Factory

  setup %{conn: conn} do
    conn |> setup_conn
  end

  test "shows no projects when none inserted", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert html_response(conn, 200) =~ "No projects to list"
  end

  test "shows projects when at least one is inserted", %{conn: conn, admin_user: user} do
    project = Factory.insert(:project, user: user)
    conn = get conn, project_path(conn, :index)
    assert html_response(conn, 200) =~ project.title
    assert html_response(conn, 200) =~ project.description
  end
end
