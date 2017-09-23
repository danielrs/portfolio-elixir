defmodule PortfolioWeb.DashboardController do
  use PortfolioWeb, :controller

  plug :put_layout, "dashboard.html"

  def index(conn, _params) do
    render(conn, "index.html", title: "Dashboard")
  end
end
