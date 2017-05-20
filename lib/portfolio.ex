defmodule Portfolio do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    day_milliseconds = 24*60*60*1000

    children = [
      # Start the endpoint when the application starts
      supervisor(Portfolio.Endpoint, []),
      # Start the Ecto repository
      supervisor(Portfolio.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Portfolio.Worker, [arg1, arg2, arg3]),
      worker(Cachex, [:yaml_cache, [default_ttl: day_milliseconds], []]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Portfolio.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Portfolio.Endpoint.config_change(changed, removed)
    :ok
  end
end
