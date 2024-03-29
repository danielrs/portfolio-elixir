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

:random.seed(:erlang.now)

import Ecto, only: [build_assoc: 2]

alias Ecto.Query
alias Portfolio.Repo
alias Portfolio.Role
alias Portfolio.User
alias Portfolio.Project
alias Portfolio.Post
alias Portfolio.Tag
alias Portfolio.SeedData

require Ecto.Query

defmodule Portfolio.SeedData do
  @moduledoc false

  @short_lorem """
  Ipsum mollitia nemo nam id minima Facere esse odit praesentium minima error Dolorem a impedit ex distinctio.
  """

  @lorem """
  Ipsum mollitia nemo nam id minima Facere esse odit praesentium minima error Dolorem a impedit ex distinctio non Earum minima voluptas adipisci dolor at velit possimus. Dicta illo vel inciduntyy.

  ## Nemo nam

  Ipsum mollitia **nemo** nam id minima Facere esse odit praesentium minima error Dolorem a impedit ex distinctio non Earum minima voluptas adipisci dolor at velit possimus. Dicta illo vel inciduntyy.

  ```
  defmodule Math do
    @moduledoc \"\"\"
    This module defines some useful math functions
    \"\"\"
    def fac(n) do
      if n <= 1, do: 1
      else: n * fac(n - 1)
    end

    def fib do
      Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)
    end
  end
  ```
  {: .language-elixir }

  Yes! Ipsum mollitia **nemo** nam id minima Facere esse odit praesentium minima error Dolorem a impedit ex distinctio non Earum minima voluptas adipisci dolor at velit possimus. Dicta illo vel inciduntyy.

  * one
  * two
  * three
  """

  def roles do
    [
      %{name: "admin", admin?: true},
      %{name: "user", admin?: false}
    ]
  end

  def users do
    [
      %{
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@email.com",
        password: "abc123",
        password_confirmation: "abc123",
        role: :admin
      }
    ]
  end

  def projects do
    [
      %{
        title: "Typing.js",
        description: "jQuery plugin for typing animations",
        homepage: "https://github.com/DanielRS/typing.js",
        date: Ecto.Date.utc
      },
      %{
        title: "Greed",
        description: "Semantic grid system for Less CSS framework",
        homepage: "https://github.com/DanielRS/greed",
        date: Ecto.Date.utc
      },
      %{
        title: "Portfolio CMS",
        description: "Mini-CMS that I use for my portfolio website",
        homepage: "https://github.com/DanielRS/portfolio",
        date: Ecto.Date.utc
      }
    ]
  end

  def posts do
    [
      %{
        title: "Some of my favorite Vim plugins",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Some of my favorite Vim plugins (Unpublished)",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: false
      },
      %{
        title: "Why functional programming is better",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "How to learn Haskell",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Web development and functional programming",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Why immutability helps us think clearer",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Must have skill for any serious developer",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Lazy evaluation",
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "OOP knees before functional programming",
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Don't overuse OOP",
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Common CSS mistakes",
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "Create a paginator in Elixir + Phoenix Framework",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      },
      %{
        title: "How to be awesome",
        description: @short_lorem,
        markdown: @lorem,
        date: Ecto.Date.utc,
        published?: true
      }
    ]
  end

  def tags do
    [
      %{name: "functional-programming"},
      %{name: "programming"},
      %{name: "elixir"},
      %{name: "erlang"},
      %{name: "haskell"},
      %{name: "c++"},
      %{name: "css"},
      %{name: "tutorial"},
      %{name: "how-to"},
      %{name: "api"},
      %{name: "sql"},
      %{name: "ai"},
      %{name: "open-gl"},
      %{name: "game-development"},
      %{name: "linux"},
      %{name: "vim"}
    ]
  end
end

# Roles
SeedData.roles
|> Enum.map(&Role.changeset(%Role{}, &1))
|> Enum.each(&Repo.insert!(&1))

# Users with admin permissions
for user <- SeedData.users do
  role = Repo.get_by(Role, name: Atom.to_string(user.role))
  if role do
    build_assoc(role, :users)
    |> User.changeset(user)
    |> Repo.insert!
  end
end

# Only insert for non tests
if Mix.env != :test do
  # Insert projects for a sigle user
  user = Repo.one(User, limit: 1)
  if user do
    for project <- SeedData.projects do
      build_assoc(user, :projects)
      |> Project.changeset(project)
      |> Repo.insert!
    end
  end

  # Insert posts for a single user
  user = Repo.one(User, limit: 1)
  if user do
    for post <- SeedData.posts do
      build_assoc(user, :posts)
      |> Post.changeset(post)
      |> Repo.insert!
    end
  end

  # Insert tags
  for tag <- SeedData.tags do
    Tag.changeset(%Tag{}, tag)
    |> Repo.insert!
  end

  tags = Repo.all(Tag)
  # Link all posts to some tags
  for post <- (Post |> Query.preload(:tags) |> Repo.all) do
    tag_count = :random.uniform * 100 |> trunc |> rem(4)
    post_tags = tags |> Enum.take_random(tag_count)
    post |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:tags, post_tags) |> Repo.update!
  end

  # Links all projects to some tags
  for project <- (Project |> Query.preload(:tags) |> Repo.all) do
    tag_count = :random.uniform * 100 |> trunc |> rem(4)
    project_tags = tags |> Enum.take_random(tag_count)
    project |> Ecto.Changeset.change |> Ecto.Changeset.put_assoc(:tags, project_tags) |> Repo.update!
  end
end
