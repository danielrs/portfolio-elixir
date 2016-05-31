defmodule Portfolio.UserView do
  use Portfolio.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Portfolio.UserView, "show.json")}
  end

  def render("show.json", %{user: user}) do
    %{
      data: %{
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        email: user.email,
        role: render_one(user.role, Portfolio.UserView, "role.json", as: :role)
      }
    }
  end

  def render("role.json", %{role: role}) do
    %{
      id: role.id,
      name: role.name,
      admin?: role.admin?
    }
  end
end
