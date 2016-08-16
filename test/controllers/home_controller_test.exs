defmodule Portfolio.HomeControllerTest do
  use Portfolio.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, home_path(conn, :index)
    assert html_response(conn, 200) =~ "Daniel Rivas"
  end
end
