defmodule Portfolio.API.V1.SessionControllerTest do
  use Portfolio.ConnCase
  import Plug.Conn.Status

  alias Portfolio.Factory

  setup %{conn: conn} do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)
    invalid_user = Factory.build(:user, password: "This should not match factory password")

    {:ok, %{conn: conn, user: Map.from_struct(user), invalid_user: Map.from_struct(invalid_user)}}
  end

  test "login with valid user credentials succeeds", %{conn: conn, user: user} do
    conn = post conn, session_path(conn, :create), [session: user]
    assert json_response(conn, code(:created))
  end

  test "login with invalid user credentials fails", %{conn: conn, invalid_user: invalid_user}  do
    conn = post conn, session_path(conn, :create), [session: invalid_user]
    assert json_response(conn, code(:unprocessable_entity))
  end

  test "trying to get current user without authenticating fails", %{conn: conn}  do
    conn = get conn, session_path(conn, :show)
    assert json_response(conn, code(:forbidden))
  end

  test "trying to get current user after authenticating succeeds", %{conn: conn, user: user}  do
    {:ok, conn} = login_user(conn, user)
    conn = get conn, session_path(conn, :show)
    assert json_response(conn, code(:ok))
  end
end
