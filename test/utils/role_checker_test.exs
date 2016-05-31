defmodule Portfolio.RoleCheckerTest do
  use Portfolio.ModelCase

  alias Portfolio.User
  alias Portfolio.Utils.RoleChecker
  alias Portfolio.TestData

  test "admin? is true when user is admin" do
    TestData.insert_roles
    TestData.insert_users
    {:ok, admin} = get_admin
    assert RoleChecker.admin?(admin)
  end

  test "admin? is false when user is not admin" do
    TestData.insert_roles
    TestData.insert_users
    {:ok, user} = get_user
    refute RoleChecker.admin?(user)
  end

  defp get_admin do
    user = (from u in User, join: r in assoc(u, :role), where: r.admin?, limit: 1) |> Repo.one
    if user, do: {:ok, user}, else: {:error, "No admin found"}
  end

  defp get_user do
    user = (from u in User, join: r in assoc(u, :role), where: not r.admin?, limit: 1) |> Repo.one
    if user, do: {:ok, user}, else: {:error, "No user found"}
  end
end
