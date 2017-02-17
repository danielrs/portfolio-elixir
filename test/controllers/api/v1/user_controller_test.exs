defmodule Portfolio.API.V1.UserControllerTest do
  use Portfolio.ConnCase

  alias Portfolio.Factory
  alias Portfolio.User

  setup %{conn: conn} do
    conn |> setup_conn
  end

  test "list all entries on index as non-admin", %{nonadmin_conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, code(:ok))["data"] != []
  end

  @tag admin: true
  test "list all entries on index as admin", %{admin_conn: conn} do
    conn = get conn, user_path(conn, :index)
    assert json_response(conn, code(:ok))["data"] != []
  end

  test "show chosen resources as non-admin", %{nonadmin_conn: conn} do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)

    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, code(:ok))["data"] == %{
      "id" => user.id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "email" => user.email,
      "role" => %{"id" => role.id, "name" => role.name, "admin?" => role.admin?}
    }
  end


  @tag admin: true
  test "show chosen resources as admin", %{admin_conn: conn} do
    role = Factory.insert(:role)
    user = Factory.insert(:user, role: role)

    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, code(:ok))["data"] == %{
      "id" => user.id,
      "first_name" => user.first_name,
      "last_name" => user.last_name,
      "email" => user.email,
      "role" => %{"id" => role.id, "name" => role.name, "admin?" => role.admin?}
    }

  end

  test "doest not show resources when non-existent", %{nonadmin_conn: conn} do
    assert_error_sent code(:not_found), fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "does not create when user is not admin", %{nonadmin_conn: conn} do
    user_params = Factory.build(:user) |> Map.from_struct
    conn = post conn, user_path(conn, :create), user: user_params
    assert json_response(conn, code(:forbidden))["errors"] != %{}
  end

  @tag admin: true
  test "creates and renders resource when data is valid", %{admin_conn: conn} do
    role = Factory.insert(:role)
    user_params = Factory.params_for_2(:user, role_id: role.id)
    conn = post conn, user_path(conn, :create), user: user_params
    assert json_response(conn, code(:created))["data"]["id"]
    assert Repo.get_by(User, user_params |> Map.drop([:password, :password_confirmation, :password_hash]))
  end

  @tag admin: true
  test "does not create resource and renders errors when data is invalid", %{admin_conn: conn} do
    conn = post conn, user_path(conn, :create), user: %{}
    assert json_response(conn, code(:unprocessable_entity))["errors"] != %{}
  end

  test "doest not update chosen resources when user is not admin", %{nonadmin_conn: conn} do
    user = Factory.insert(:user)
    conn = patch conn, user_path(conn, :update, user), user: %{}
    assert json_response(conn, code(:forbidden))["errors"] != %{}
  end

  @tag admin: true
  test "updates and renders chosen resource when data is valid", %{admin_conn: conn} do
    user = Factory.insert(:user)
    updated_role = Factory.insert(:role, admin?: true)
    updated_user = Factory.build(:user, role_id: updated_role.id) |> Map.from_struct
    conn = patch conn, user_path(conn, :update, user), user: updated_user
    assert json_response(conn, code(:ok))["data"]["id"]
    assert Repo.get_by(User, updated_user |> Map.take([:first_name, :last_name, :email]))
  end

  @tag admin: true
  test "does not update and renders errors when data is invalid", %{admin_conn: conn} do
    user = Factory.insert(:user)
    conn = patch conn, user_path(conn, :update, user), user: %{first_name: ""}
    assert json_response(conn, code(:unprocessable_entity))["errors"] != %{}
  end

  test "non-admin cannot delete chosen resource", %{nonadmin_conn: conn} do
    user = Factory.insert(:user)
    conn = delete conn, user_path(conn, :delete, user)
    assert json_response(conn, code(:forbidden))["errors"] != %{}
  end

  @tag admin: true
  test "admin deletes chosen resource", %{admin_conn: conn} do
    user = Factory.insert(:user)
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, code(:no_content))
    refute Repo.get(User, user.id)
  end
end
