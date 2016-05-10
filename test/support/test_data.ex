defmodule Portfolio.TestData do

  import Ecto
  import Ecto.Changeset, only: [update_change: 3]

  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.Post

  def insert_roles do
    roles
    |> Enum.map(&Role.changeset(%Role{}, &1))
    |> Enum.each(&Repo.insert!(&1))
  end

  def insert_users do
    for user <- users do
      role = Repo.get_by!(Role, name: user.role_name)
      User.changeset(%User{role_id: role.id}, user)
    end
    |> Enum.each(&Repo.insert!(&1))
  end

  def insert_projects do
    for user <- Repo.all(User), project <- projects do
      build_assoc(user, :projects) |> Project.changeset(project)
    end
    |> List.flatten
    |> Enum.each(&Repo.insert!(&1))
  end

  def insert_posts do
    for user <- Repo.all(User), post <- posts do
      build_assoc(user, :posts)
      |> Post.changeset(post)
      |> update_change(:slug, &(&1 <> " - " <> user.first_name))
    end
    |> List.flatten
    |> Enum.each(&Repo.insert!(&1))
  end

  def roles do
    [
      %{id: 1, name: "admin", admin: true},
      %{id: 2, name: "user", admin: false}
    ]
  end

  def user_admin do
    %{
      first_name: "Daniel",
      last_name: "Rivas",
      email: "daniel.rivas@email.com",
      password: "ONk0s13S",
      password_confirmation: "ONk0s13S",
      role_name: "admin"
    }
  end

  def user do
    %{
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@email.com",
      password: "12345678",
      password_confirmation: "12345678",
      role_name: "user"
    }
  end

  def users do
    [user_admin, user]
  end

  def projects do
    [
      %{
        title: "Marquee",
        description: "Markdown transpiler",
        homepage: "https://github.com/DanielRS/marquee",
        content: "",
        date: Ecto.Date.utc
      },
      %{
        title: "Typing.js",
        description: "jQuery typing animations",
        homepage: "https://github.com/DanielRS/typing.js",
        content: "",
        date: Ecto.Date.utc
      },
      %{
        title: "Greed",
        description: "Semantic grid system for LESS",
        homepage: "https://github.com/DanielRS/greed",
        content: "",
        date: Ecto.Date.utc
      }
    ]
  end

  def posts do
    [
      %{
        title: "Post 1",
        slug: "post-uno",
        markdown: "**This** is the post *1*",
        date: Ecto.Date.utc
      },
      %{
        title: "Post 2",
        slug: "post-dos",
        markdown: "**This** is the post *2*",
        date: Ecto.Date.utc
      },
      %{
        title: "Post 3",
        markdown: "**This** is the post _3_",
        date: Ecto.Date.utc
      },
      %{
        title: "Post 4",
        markdown: "**This** is the post __4__",
        date: Ecto.Date.utc
      }
    ]
  end
end
