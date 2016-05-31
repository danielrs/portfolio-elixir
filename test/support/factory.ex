defmodule Portfolio.Factory do
  use ExMachina.Ecto, repo: Portfolio.Repo

  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.User

  def factory(:role) do
    %Role{
      name: sequence(:name, &"Test Role #{&1}"),
      admin?: false
    }
  end

  def factory(:user) do
    %User{
      first_name: "John",
      last_name: "Doe",
      email: sequence(:email, &"email-#{&1}@example.com"),
      password: "test1234",
      password_confirmation: "test1234",
      password_hash: Comeonin.Bcrypt.hashpwsalt("test1234"),
      role: build(:role)
    }
  end

  def factory(:project) do
    %Project{
      title: "Some title",
      description: "Some description",
      homepage: "Some homepage",
      content: "",
      date: Ecto.Date.utc,
      user: build(:user)
    }
  end
end
