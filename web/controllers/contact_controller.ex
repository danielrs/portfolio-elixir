defmodule Portfolio.ContactController do
  use Portfolio.Web, :controller
  alias Portfolio.Message

  plug Portfolio.Plug.PageTitle, title: "Contact - Daniel Rivas"
  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    changeset = Message.changeset(%Message{})
    render conn, "index.html", changeset: changeset
  end

  def new(conn, %{"message" => contact_params}) do
    changeset = Message.changeset(%Message{}, contact_params)

    if changeset.valid? do
      conn
      |> put_flash(:info, "Message sent")
      |> render("index.html", changeset: changeset)
    else
      conn
      |> put_flash(:info, "Message not sent")
      |> render("index.html", changeset: changeset)
    end
  end
end
