defmodule Portfolio.PostController do
  use Portfolio.Web, :controller

  alias Portfolio.Post
  alias Portfolio.User

  plug Portfolio.Plug.UserResourceModification when action in [:create, :update, :delete]
  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, %{"user_id" => user_id}) do
    user = Repo.get!(User, user_id)
    posts = assoc(user, :posts) |> Ecto.Query.order_by(desc: :date) |> Repo.all
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"user_id" => user_id, "post" => post_params}) do
    user = Repo.get!(User, user_id)
    changeset = user |> build_assoc(:posts) |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_post_path(conn, :show, user, post))
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    post = Repo.get!(Post, id, user_id: user_id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"user_id" => user_id, "id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id, user_id: user_id) |> Map.take([:id, :user_id])
    changeset = Post.changeset(struct(Post, post), post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        render(conn, "show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    post = Repo.get!(Post, id, user_id: user_id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end
end
