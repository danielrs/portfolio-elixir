defmodule Portfolio.ProjectTest do
  use Portfolio.DataCase

  alias Portfolio.Project

  @valid_attrs %{title: "Marquee",
                 description: "Markdown transpiler",
                 homepage: "https://github.com/DanielRS/Marquee",
                 content: "Some content",
                 date: "2010-04-17",
                 user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Project.changeset(%Project{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Project.changeset(%Project{}, @invalid_attrs)
    refute changeset.valid?
  end
end
