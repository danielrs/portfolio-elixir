defmodule Portfolio.ContactController do
  use Portfolio.Web, :controller
  alias Portfolio.Message
  alias Portfolio.Mailer

  plug Portfolio.Plug.Menu

  require Logger

  def index(conn, _params) do
    changeset = Message.changeset(%Message{})
    do_render(conn, changeset)
  end

  def create(conn, %{"message" => contact_params}) do
    changeset = Message.changeset(%Message{}, contact_params)
    changeset = %{changeset | action: :create}
    if changeset.valid? do
      case send_message(changeset) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "Message sent")
          |> redirect(to: contact_path(conn, :index))
        {:error, message} ->
          conn
          |> put_flash(:info, message)
          |> redirect(to: contact_path(conn, :index))
      end
    else
      do_render(conn, changeset)
    end
  end

  defp do_render(conn, changeset) do
    conn
    |> SEO.put_title("Contact")
    |> SEO.put_meta("Contact me")
    |> render("index.html", changeset: changeset)
  end

  defp send_message(changeset) do
    changes = changeset.changes
    Mailer.send_contact_email changes[:name],
                              changes[:email],
                              changes[:subject],
                              changes[:text]
  end
end
