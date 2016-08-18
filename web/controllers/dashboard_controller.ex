defmodule Portfolio.DashboardController do
  use Portfolio.Web, :controller

  plug :put_layout, "dashboard.html"

  def index(conn, _params) do
    render(conn, "index.html", page_title: page_title("Dashboard"))
  end
end
