defmodule Portfolio.Factory do
  @moduledoc """
  Factory for different models. params_for copied from ex_machina repo
  """
  use ExMachina.Ecto, repo: Portfolio.Repo
  alias Portfolio.Factory

  alias Portfolio.Role
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.Post
  alias Portfolio.Tag

  # BUILD
  def role_factory do
    %Role{
      name: sequence(:name, &"Test Role #{&1}"),
      admin?: false
    }
  end

  def user_factory do
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

  def project_factory do
    %Project{
      title: "Some title",
      description: "Some description",
      homepage: "Some homepage",
      content: "Some content",
      language: "Some language",
      date: Ecto.Date.utc,
      user: build(:user),
      tags: [build(:tag)]
    }
  end

  def post_factory do
    %Post{
      title: "Some title",
      slug: "some-slug",
      description: "Some description",
      markdown: "# Some markdown",
      html: "<h1>Some markdown</h1>\n",
      date: Ecto.Date.utc,
      published?: true,
      user: build(:user),
      tags: [build(:tag)]
    }
  end

  def post_with_tags_factory do
    post_factory
    |> Map.put(:tags, [build(:tag)])
  end

  def tag_factory do
    %Tag {
      name: sequence(:name, &"tag-#{&1}")
    }
  end

  # PARAMS
  def params_for_2(factory_name, attrs \\ %{}) do
    do_params_for_2(factory_name, attrs) |> Map.drop([:__meta__, :inserted_at, :updated_at])
  end

  defp do_params_for_2(:user, attrs) do
    Factory.build(:user, attrs) |> Map.from_struct |> Map.drop([:id, :posts, :projects, :role])
  end
  defp do_params_for_2(:project, attrs) do
    Factory.build(:project, attrs) |> Map.from_struct |> Map.drop([:id, :user_id, :user, :tags])
  end
  defp do_params_for_2(:post, attrs) do
    Factory.build(:post, attrs) |> Map.from_struct |> Map.drop([:id, :user_id, :user, :tags])
  end
end
