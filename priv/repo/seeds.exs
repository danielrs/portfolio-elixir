# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Portfolio.Repo.insert!(%Portfolio.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto
alias Portfolio.{Repo, User, Project, Post, SeedData}

defmodule Portfolio.SeedData do
  @moduledoc false

  def user_daniel_rivas do
    %{
      first_name: "Daniel",
      last_name: "Rivas",
      email: "ers.daniel@gmail.com",
      password: "ONk0s13S"
    }
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
    [user_daniel_rivas, user]
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

SeedData.users
|> Enum.map(&User.changeset(%User{}, &1))
|> Enum.each(&Repo.insert!(&1))

for user <- Repo.all(User), project <- SeedData.projects do
  build_assoc(user, :projects) |> Project.changeset(project)
end
|> List.flatten
|> Enum.each(&Repo.insert!(&1))

for user <- Repo.all(User), post <- SeedData.posts do
  build_assoc(user, :posts)
  |> Post.changeset(post)
  |> Ecto.Changeset.update_change(:slug, &(&1 <> " - " <> user.first_name))
end
|> List.flatten
|> Enum.each(&Repo.insert!(&1))
