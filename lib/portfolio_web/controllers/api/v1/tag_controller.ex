defmodule PortfolioWeb.API.V1.TagController do
  use PortfolioWeb, :controller

  import Portfolio.API.V1.Plugs

  alias Portfolio.Tag
  alias Ecto.Query

  plug :ensure_admin when action in [:create, :update, :delete]

  def index(conn, _params) do
    tags = Tag |> Query.order_by(asc: :name) |> Repo.all
    render(conn, "index.json", tags: tags)
  end

  def create(conn, %{"tag" => tag_params}) do
    changeset = Tag.changeset(%Tag{}, tag_params)

    if tag = changeset.valid? && Repo.get_by(Tag, name: changeset.changes.name) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", tag_path(conn, :show, tag))
      |> render("show.json", tag: tag)
    else
      case Repo.insert(changeset) do
        {:ok, tag} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", tag_path(conn, :show, tag))
          |> render("show.json", tag: tag)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(PortfolioWeb.ChangesetView, "error.json", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    render(conn, "show.json", tag: tag)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag, tag_params)

    case Repo.update(changeset) do
        {:ok, tag} ->
          render(conn, "show.json", tag: tag)
        {:error, changeset} ->
          conn
          |> put_status(:unprocessable_entity)
          |> render(PortfolioWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    Repo.delete!(tag)
    send_resp(conn, :no_content, "")
  end
end
