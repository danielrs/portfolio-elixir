defmodule Portfolio.UserTest do
  use Portfolio.ModelCase

  alias Portfolio.User

  @valid_attrs %{first_name: "John",
                 last_name: "Doe",
                 email: "john.doe@gmail.com",
                 password: "12345678"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
