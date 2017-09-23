defmodule Portfolio.UserTest do
  use Portfolio.DataCase

  alias Portfolio.User

  @valid_attrs %{first_name: "John",
                 last_name: "Doe",
                 email: "john.doe@gmail.com",
                 password: "12345678",
                 password_confirmation: "12345678",
                 role_id: 2}
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
