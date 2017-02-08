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
#
# This file (unlike seeds.dev.exs) populates the minimum needed
# values in the database. That is the values in the roles table.

:random.seed(:erlang.now)

alias Portfolio.Repo
alias Portfolio.Role

# Populates the roles
[
  %{name: "admin", admin?: true},
  %{name: "user", admin?: false}
]
|> Enum.map(&Role.changeset(%Role{}, &1))
|> Enum.each(&Repo.insert(&1))
