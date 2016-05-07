defmodule Portfolio.SessionView do
  use Portfolio.Web, :view

  def render("show.json", %{jwt: jwt, user: user}) do
    %{data: %{jwt: jwt, user: user}}
  end

  def render("error.json", _params) do
    %{error: "Invalid email or password"}
  end

  def render("forbidden.json", %{error: error}) do
    %{error: error}
  end
end
