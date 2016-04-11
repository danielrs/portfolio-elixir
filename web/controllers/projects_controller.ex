defmodule Portfolio.ProjectsController do
  use Portfolio.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
