defmodule Portfolio.BlogController do
  use Portfolio.Web, :controller

  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    render conn, "index.html", page_title: "Blog - Daniel Rivas"
  end
end
