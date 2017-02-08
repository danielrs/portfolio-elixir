defmodule Portfolio.Seeds do
  alias Portfolio.Repo
  alias Portfolio.Role

  @doc """
  Sets up the basic roles in the database if they don't
  exists already.
  """
  def setup_roles do
    if !Repo.get_by(Role, name: "admin") do
      role = Role.changeset(%Role{}, %{name: "admin", admin?: true})
      Repo.insert(role)
    end

    if !Repo.get_by(Role, name: "user") do
      role = Role.changeset(%Role{}, %{name: "user", admin?: false})
      Repo.insert(role)
    end
  end
end
