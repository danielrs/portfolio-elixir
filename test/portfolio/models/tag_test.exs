defmodule Portfolio.TagTest do
  use Portfolio.DataCase

  alias Portfolio.Factory
  alias Portfolio.Tag

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, Factory.params_for(:tag))
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, Factory.params_for(:tag, name: ""))
    refute changeset.valid?
  end

  test "changeset fixes tag name" do
    changeset = Tag.changeset(%Tag{}, Factory.params_for(:tag, name: "tag NUMBER 0"))
    assert changeset.valid?
    assert changeset.changes.name == "tag-number-0"
  end

  test "changeset keeps tag name" do
    changeset = Tag.changeset(%Tag{}, Factory.params_for(:tag, name: "tag-number-0"))
    assert changeset.valid?
    assert changeset.changes.name == "tag-number-0"
  end
end
