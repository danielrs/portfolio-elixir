ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Portfolio.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Portfolio.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Portfolio.Repo)

