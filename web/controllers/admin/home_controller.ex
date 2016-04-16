defmodule Portfolio.Admin.HomeController do
  use Portfolio.Web, :admin_controller

  plug Portfolio.Plug.PageTitle, title: "Dashboard - Daniel Rivas"

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
