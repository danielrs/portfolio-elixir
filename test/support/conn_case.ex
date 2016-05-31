defmodule Portfolio.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Portfolio.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
      import Plug.Conn.Status, only: [code: 1]

      import Portfolio.Router.Helpers

      # The default endpoint for testing
      @endpoint Portfolio.Endpoint

      defp login_user(conn, user) do
        auth_conn = post conn, session_path(conn, :create), session: %{email: user.email, password: user.password}
        status = Map.get(auth_conn, :status)
        resp_body = auth_conn.resp_body |> Poison.decode!

        if status >= 200 and status < 300 do
          new_conn = conn |> put_req_header("authorization", get_in(resp_body, ["data", "jwt"]))
          {:ok, new_conn}
        else
          {:error, get_in(resp_body, [:data, :error])}
        end
      end
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Portfolio.Repo, [])
    end

    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end
