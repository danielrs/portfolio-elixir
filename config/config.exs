# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :portfolio, Portfolio.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "QljouOFRV2gXf+4ncD9uIz+WnaQYZDb0q1qq0PM6wTA/uUFBN/WELd6KtEKMRLGQ",
  render_errors: [accepts: ~w(html json)],
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

# Other user facing configuration
config :portfolio,
  showcase_email: "ers.daniel@gmail.com",
  mailgun_domain: System.get_env("MAILGUN_DOMAIN"),
  mailgun_key: System.get_env("MAILGUN_KEY")

# import_config "config.secret.exs"
