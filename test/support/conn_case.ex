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

      defp setup_conn(conn) do
        alias Portfolio.Factory

        nonadmin_role = Factory.insert(:role)
        admin_role    = Factory.insert(:role, admin?: true)
        nonadmin_user = Factory.insert(:user, role: nonadmin_role)
        admin_user    = Factory.insert(:user, role: admin_role)

        Application.put_env(:portfolio, :showcase_email, admin_user.email)

        {:ok, nonadmin_conn} = login_user(conn, nonadmin_user)
        {:ok, admin_conn} = login_user(conn, admin_user)

        {:ok,
         conn: conn,
         nonadmin_conn: nonadmin_conn,
         admin_conn: admin_conn,
         nonadmin_user: nonadmin_user,
         admin_user: admin_user}
      end

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
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Portfolio.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Portfolio.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
