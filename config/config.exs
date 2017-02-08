# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :portfolio,
  ecto_repos: [Portfolio.Repo]

# Configures the endpoint
config :portfolio, Portfolio.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "QljouOFRV2gXf+4ncD9uIz+WnaQYZDb0q1qq0PM6wTA/uUFBN/WELd6KtEKMRLGQ",
  render_errors: [view: Portfolio.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Portfolio.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Portfolio",
  ttl: {30, :days},
  verify_issuer: true,
  secret_key: "lksdjowiurowieurlkjsdlwwer",
  serializer: Portfolio.GuardianSerializer

# Mailgun
config :portfolio,
  mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
  mailgun_key: System.get_env("MAILGUN_KEY")

# Theme configuration
config :portfolio,
  site_name: "Daniel Rivas",
  showcase_email: "daniel.rivas@email.com",
  theme: :hairline,
  static_path: Path.expand("../priv/static", __DIR__)
