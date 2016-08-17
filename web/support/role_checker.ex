defmodule Portfolio.RoleChecker do
  alias Portfolio.Repo
  alias Portfolio.Role
  alias Portfolio.User

  @spec admin?(User) :: boolean
  def admin?(user) do
    role = Repo.get(Role, user.role_id)
    role.admin?
  end
end
