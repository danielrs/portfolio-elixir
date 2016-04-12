defmodule Portfolio.BlogController do
  use Portfolio.Web, :controller

  plug Portfolio.Plug.PageTitle, title: "Blog - Daniel Rivas"
  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    render conn, "index.html"
  end
end
