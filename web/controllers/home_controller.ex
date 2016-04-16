defmodule Portfolio.HomeController do
  use Portfolio.Web, :controller

  plug Portfolio.Plug.PageTitle, title: "Daniel Rivas"
  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
