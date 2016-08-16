defmodule Portfolio.ContactController do
  use Portfolio.Web, :controller
  alias Portfolio.Message
  alias Portfolio.Mailer

  plug :scrub_params, "message" when action in [:create]
  plug Portfolio.Plug.Menu

  def index(conn, _params) do
    changeset = Message.changeset(%Message{})
    do_render(conn, changeset)
  end

  def create(conn, %{"message" => contact_params}) do
    changeset = Message.changeset(%Message{}, contact_params)

    if changeset.valid? do
      send_message(changeset)
      conn
      |> put_flash(:info, "Message sent")
      |> redirect(to: contact_path(conn, :index))
    else
      do_render(conn, changeset)
    end
  end

  defp do_render(conn, changeset) do
    render(conn, "index.html", page_title: "Contact - Daniel Rivas", changeset: changeset)
  end

  defp send_message(changeset) do
    changes = changeset.changes
    Mailer.send_contact_email changes[:name],
                              changes[:email],
                              changes[:subject],
                              changes[:text]
  end
end
