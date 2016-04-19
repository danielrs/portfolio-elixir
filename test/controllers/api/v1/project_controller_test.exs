defmodule Portfolio.ProjectControllerTest do
  use Portfolio.ConnCase

  alias Portfolio.TestData
  alias Portfolio.Project

  @valid_attrs %{content: "some content", date: Ecto.Date.utc, description: "some content", homepage: "some content", title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    TestData.insert_users
    auth_response = post conn, session_path(conn, :create), [session: TestData.user]
    %{"jwt" => jwt, "user" => %{"id" => user_id}} = auth_response.resp_body |> Poison.decode!
    new_conn = conn
               |> put_req_header("accept", "application/json")
               |> put_req_header("authorization", jwt)
    {:ok, conn: new_conn, user_id: user_id}
  end

  test "lists all entries on index before inserting", %{conn: conn} do
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "lists all entries on index after inserting", %{conn: conn, user_id: user_id} do
    TestData.insert_projects
    conn = get conn, project_path(conn, :index)
    assert json_response(conn, 200)["data"] != []
  end

  test "shows chosen resource", %{conn: conn, user_id: user_id} do
    TestData.insert_projects
    [project] = Repo.all(from p in Project, where: p.user_id == ^user_id, limit: 1)
    conn = get conn, project_path(conn, :show, project)
    assert json_response(conn, 200)["data"] == %{"id" => project.id,
      "title" => project.title,
      "description" => project.description,
      "homepage" => project.homepage,
      "content" => project.content,
      "date" => Ecto.Date.to_string(project.date),
      "user_id" => project.user_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, project_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, project_path(conn, :create), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, user_id: user_id} do
    project = Repo.insert! project_for_user(user_id)
    conn = put conn, project_path(conn, :update, project), project: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    # assert Repo.get_by(Project, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, user_id: user_id} do
    project = Repo.insert! project_for_user(user_id)
    conn = put conn, project_path(conn, :update, project), project: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, user_id: user_id} do
    project = Repo.insert! project_for_user(user_id)
    conn = delete conn, project_path(conn, :delete, project)
    assert response(conn, 204)
    refute Repo.get(Project, project.id)
  end

  defp project_for_user(user_id) do
    params = @valid_attrs |> Map.put(:user_id, user_id)
    struct(Project, params)
  end
end
