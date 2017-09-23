defmodule Portfolio.PostTest do
  use Portfolio.DataCase

  alias Portfolio.Post

  @valid_attrs %{title: "Some REALLY awesome title!!!...",
                 slug: "some-slug-not-from-title",
                 description: "Some description",
                 markdown: "# Some Markdown",
                 html: "*I was not generated yet",
                 date: "2010-04-17",
                 published?: true,
                 user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset generates slug from title" do
    changeset = Post.changeset(%Post{}, Map.delete(@valid_attrs, :slug))
    assert changeset.changes.slug == "some-really-awesome-title"
  end

  test "changeset takes slug from parameters" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.changes.slug == "some-slug-not-from-title"
  end

  test "changeset translates markdown to HTML" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.changes.html == "<h1>Some Markdown</h1>\n"
  end
end
