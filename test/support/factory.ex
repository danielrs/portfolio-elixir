defmodule Portfolio.Factory do
  @moduledoc """
  Factory for different models. params_for copied from ex_machina repo
  """
  use ExMachina.Ecto, repo: Portfolio.Repo
  alias Portfolio.Factory

  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User
  alias Portfolio.Project
  alias Portfolio.Post


  def params_for(factory_name, attrs \\ %{}) do
    Factory.build(factory_name, attrs)
    |> drop_ecto_fields
    |> Enum.filter(fn {_, v} -> v != nil end)
    |> Enum.into(%{})
  end

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

  def factory(:post) do
    %Post{
      title: "Some title",
      slug: "some-slug",
      markdown: "# Some markdown",
      html: "<h1>Some markdown</h1>\n",
      date: Ecto.Date.utc,
      published: false,
      user: build(:user)
    }
  end

  defp drop_ecto_fields(record = %{__struct__: struct, __meta__: %{__struct__: Ecto.Schema.Metadata}}) do
    record
    |> Map.from_struct
    |> Map.delete(:__meta__)
    |> Map.drop(struct.__schema__(:associations))
    |> Map.drop(struct.__schema__(:primary_key))
  end
  defp drop_ecto_fields(record) do
    raise ArgumentError, "#{inspect record} is not an Ecto model. Use `build` instead."
  end
end
