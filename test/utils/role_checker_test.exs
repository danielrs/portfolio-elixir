defmodule Portfolio.RoleCheckerTest do
  use Portfolio.ModelCase

  alias Portfolio.Factory
  alias Portfolio.Utils.RoleChecker

  test "RoleChecker.admin? is true when user is admin" do
    role = Factory.create(:role, admin?: true)
    user = Factory.create(:user, role: role)
    assert RoleChecker.admin?(user)
  end

  test "RoleChecker.admin? is false when user is not admin" do
    user = Factory.create(:user, admin?: false)
    refute RoleChecker.admin?(user)
  end
end
