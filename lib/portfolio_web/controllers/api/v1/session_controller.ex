defmodule PortfolioWeb.API.V1.SessionController do
  use PortfolioWeb, :controller

  alias Portfolio.Session

  def show(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    user = Guardian.Plug.current_resource(conn)
    conn
    |> put_status(:ok)
    |> render("show.json", jwt: jwt, user: user)
  end

  def create(conn, %{"session" => session_params}) do
    changeset = Session.changeset(%Session{}, session_params)
    case Session.confirm_credentials(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)
        conn
        |> put_status(:created)
        |> render("show.json", jwt: jwt, user: user)
      {:error, _changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json")
    end
  end

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> render(PortfolioWeb.API.V1.SessionView, "forbidden.json", error: "Not authenticated")
  end
end
