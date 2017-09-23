# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Custom configuration
config :portfolio,
  site_name: "Daniel Rivas",
  showcase_email: System.get_env("PORTFOLIO_SHOWCASE_EMAIL") || "john.doe@email.com"

# General application configuration
config :portfolio,
  namespace: Portfolio,
  ecto_repos: [Portfolio.Repo]

# Configures the endpoint
config :portfolio, PortfolioWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "IaUPLNesc6cDPYzCY4xieNdYzLTntyq+JHctCeUkq/ZffADqF9nQor/sgc2rWXIg",
  render_errors: [view: PortfolioWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Portfolio.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Guardian
config :guardian, Guardian,
  issuer: "Portfolio",
  ttl: {30, :days},
  allowed_drift: 2000,
  secret_key: "lksdjowiurowieurlkjsdlwwer",
  serializer: Portfolio.Guardian

# Configure Mailgun
config :portfolio,
  mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
  mailgun_key: System.get_env("MAILGUN_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
