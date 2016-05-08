defmodule Portfolio.PostController do
  use Portfolio.Web, :controller

  alias Portfolio.Post

  plug :scrub_params, "post" when action in [:create, :update]

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    posts = assoc(user, :posts) |> Post.order_by_date |> Repo.all
    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)
    changeset = user |> build_assoc(:posts) |> Post.changeset(post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, post))
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Portfolio.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    post = Repo.get!(Post, id, user_id: user.id)
    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    user = Guardian.Plug.current_resource(conn)
    post = Repo.get!(Post, id, user_id: user.id) |> Map.take([:id, :user_id])
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

  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    post = Repo.get!(Post, id, user_id: user.id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end
end
