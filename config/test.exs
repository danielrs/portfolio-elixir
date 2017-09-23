use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :portfolio, PortfolioWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :portfolio, Portfolio.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "devdb",
  password: "devdb",
  database: "portfolio_test",
  hostname: "devdb",
  pool: Ecto.Adapters.SQL.Sandbox
