defmodule Portfolio.SessionControllerTest do
  use Portfolio.ConnCase
  import Plug.Conn.Status

  alias Portfolio.TestData

  setup %{conn: conn} do
    TestData.insert_roles
    TestData.insert_users
    {:ok, %{conn: conn}}
  end

  @valid_user TestData.user
  @invalid_user %{}

  test "POST /api/v1/session with valid user credentials succeeds", %{conn: conn} do
    conn = post conn, session_path(conn, :create), [session: @valid_user]
    assert json_response(conn, code(:created))
  end

  test "POST /api/v1/session with invalid user credentials fails", %{conn: conn}  do
    conn = post conn, session_path(conn, :create), [session: @invalid_user]
    assert json_response(conn, code(:unprocessable_entity))
  end

  test "GET /api/v1/session without authenticating fails", %{conn: conn}  do
    conn = get conn, session_path(conn, :show)
    assert json_response(conn, code(:forbidden))
  end

  test "GET /api/v1/session after authenticating succeeds", %{conn: conn}  do
    conn = get authorized_conn(conn), session_path(conn, :show)
    assert json_response(conn, code(:ok))
  end

  defp authorized_conn(conn) do
    auth_conn = post conn, session_path(conn, :create), [session: @valid_user]
    %{"data" => %{"jwt" => jwt}} = auth_conn.resp_body |> Poison.decode!
    conn |> put_req_header("authorization", jwt)
  end
end
