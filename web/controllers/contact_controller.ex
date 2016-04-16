defmodule Portfolio.ContactController do
  use Portfolio.Web, :controller
  alias Portfolio.Message

  plug :scrub_params, "message" when action in [:new]
  plug Portfolio.Plug.PageTitle, title: "Contact - Daniel Rivas"
  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    changeset = Message.changeset(%Message{})
    render(conn, "index.html", changeset: changeset)
  end

  def new(conn, %{"message" => contact_params}) do
    changeset = Message.changeset(%Message{}, contact_params)

    if changeset.valid? do
      send_message
      conn
      |> put_flash(:info, "Message sent")
      |> redirect(to: contact_path(conn, :index))
    else
      render(conn, "index.html", changeset: changeset)
    end
  end

  defp send_message do
  end
end
