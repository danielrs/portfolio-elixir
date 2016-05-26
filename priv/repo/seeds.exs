# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Portfolio.Repo.insert!(%Portfolio.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Portfolio.Repo
alias Portfolio.Role
alias Portfolio.SeedData

defmodule Portfolio.SeedData do
  @moduledoc false
  def roles do
    [
      %{name: "admin", admin?: true},
      %{name: "user", admin?: false}
    ]
  end
end

# Roles
SeedData.roles
|> Enum.map(&Role.changeset(%Role{}, &1))
|> Enum.each(&Repo.insert!(&1))
