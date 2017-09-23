defmodule Portfolio.RoleTest do
  use Portfolio.DataCase

  alias Portfolio.Role

  @valid_attrs %{name: "admin", admin?: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Role.changeset(%Role{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Role.changeset(%Role{}, @invalid_attrs)
    refute changeset.valid?
  end
end
