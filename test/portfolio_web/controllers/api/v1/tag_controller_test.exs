defmodule PortfolioWeb.API.V1.TagControllerTest do
  use PortfolioWeb.ConnCase

  alias Portfolio.Factory
  alias Portfolio.Tag

  setup %{conn: conn} do
    conn |> setup_conn
  end

  test "list all entries on index", %{nonadmin_conn: conn} do
    Factory.insert(:tag)
    Factory.insert(:tag)
    Factory.insert(:tag)

    conn = get conn, tag_path(conn, :index)
    assert json_response(conn, code(:ok))["data"] != []
  end

  test "show chosen resource", %{nonadmin_conn: conn} do
    tag = Factory.insert(:tag)

    conn = get conn, tag_path(conn, :show, tag)
    assert json_response(conn, code(:ok))["data"] == %{
      "id" => tag.id,
      "name" => tag.name
    }
  end

  test "does not show chosen resource when non-existent", %{nonadmin_conn: conn} do
    assert_error_sent code(:not_found), fn ->
      get conn, tag_path(conn, :show, -1)
    end
  end

  test "does not create resource when user is not admin", %{nonadmin_conn: conn} do
    tag_params = Factory.build(:tag) |> Map.from_struct
    conn = post conn, tag_path(conn, :create), tag: tag_params
    assert json_response(conn, code(:forbidden))["errors"] != %{}
  end

  @tag admin: true
  test "creates and renders resource when data is valid", %{admin_conn: conn} do
    tag_params = Factory.build(:tag) |> Map.from_struct
    conn = post conn, tag_path(conn, :create), tag: tag_params
    assert json_response(conn, code(:created))["data"]["id"]
  end

  @tag admin: true
  test "returns existing resource when trying to create similar", %{admin_conn: conn} do
    tag = Factory.insert(:tag) |> Map.from_struct
    conn = post conn, tag_path(conn, :create), tag: tag
    assert json_response(conn, code(:ok))["data"]["id"]
  end

  @tag admin: true
  test "does not create and renders errors when data is invalid", %{admin_conn: conn} do
    conn = post conn, tag_path(conn, :create), tag: %{}
    assert json_response(conn, code(:unprocessable_entity))["errors"] != %{}
  end

  @tag admin: true
  test "does not update chosen resource when user is not admin", %{nonadmin_conn: conn} do
    tag = Factory.insert(:tag)
    conn = patch conn, tag_path(conn, :update, tag), tag: %{}
    assert json_response(conn, code(:forbidden))["errors"] != %{}
  end

  @tag admin: true
  test "updates and renders chosen resource when data is valid", %{admin_conn: conn} do
    tag = Factory.insert(:tag)
    conn = patch conn, tag_path(conn, :update, tag), tag: %{name: "my-new-tag"}
    assert json_response(conn, code(:ok))["data"] == %{
      "id" => tag.id,
      "name" => "my-new-tag"
    }
  end

  @tag admin: true
  test "does not update and renders errors when data is invalid", %{admin_conn: conn} do
    tag = Factory.insert(:tag)
    conn = patch conn, tag_path(conn, :update, tag), tag: %{name: ""}
    assert json_response(conn, code(:unprocessable_entity))["errors"] != %{}
  end

  test "non-admin cannot delete chosen resource", %{nonadmin_conn: conn} do
    tag = Factory.insert(:tag)
    conn = delete conn, tag_path(conn, :delete, tag)
    assert json_response(conn, code(:forbidden))["errors"] != %{}
  end

  @tag admin: true
  test "admin deletes chosen resource", %{admin_conn: conn} do
    tag = Factory.insert(:tag)
    conn = delete conn, tag_path(conn, :delete, tag)
    assert response(conn, code(:no_content))
    refute Repo.get(Tag, tag.id)
  end
end
