defmodule Portfolio.TestData do

  import Ecto
  alias Portfolio.Repo
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.Post

  def insert_all do
    insert_users
    insert_projects
  end

  def insert_users do
    changesets = for user <- users, do: User.changeset(%User{}, user)
    Enum.each(changesets, &Repo.insert!(&1))
  end

  def insert_projects do
    users = Repo.all(User)
    changesets = for user <- users, project <- projects do
      build_assoc(user, :projects) |> Project.changeset(project)
    end |> List.flatten
    Enum.each(changesets, &Repo.insert!(&1))
  end

  def insert_posts do
    users = Repo.all(User)
    changesets = for user <- users, post <- posts do
      build_assoc(user, :posts) |> Post.changeset(post)
    end |> List.flatten
    Enum.each(changesets, &Repo.insert!(&1))
  end

  def user do
    %{
      first_name: "John",
      last_name: "Doe",
      email: "john.doe@email.com",
      password: "12345678"
    }
  end

  def users do
    [user]
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
      }
    ]
  end
end
