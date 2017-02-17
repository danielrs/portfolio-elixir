defmodule Portfolio.HomeControllerTest do
  use Portfolio.ConnCase

  setup %{conn: conn} do
    conn |> setup_conn
  end

  test "GET /", %{conn: conn} do
    conn = get conn, home_path(conn, :index)
    assert html_response(conn, 200) =~ "Daniel Rivas"
  end
end
