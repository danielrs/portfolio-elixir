defmodule Portfolio.RoleCheckerTest do
  use Portfolio.ModelCase

  alias Portfolio.Factory
  alias Portfolio.Utils.RoleChecker

  test "RoleChecker.admin? is true when user is admin" do
    role = Factory.insert(:role, admin?: true)
    user = Factory.insert(:user, role: role)
    assert RoleChecker.admin?(user)
  end

  test "RoleChecker.admin? is false when user is not admin" do
    role = Factory.insert(:role, admin?: false)
    user = Factory.insert(:user, role: role)
    refute RoleChecker.admin?(user)
  end
end
