# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :predictor,
  ecto_repos: [Predictor.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :predictor, PredictorWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PredictorWeb.ErrorHTML, json: PredictorWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Predictor.PubSub,
  live_view: [signing_salt: "4e+dsryP"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  predictor: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/predictor/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  predictor: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/predictor/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :data_preprocessor, DataPreprocessor.Repo,
  database: "sports",
  username: "postgres",
  password: "toorroot",
  hostname: "localhost"

config :data_preprocessor, ecto_repos: [DataPreprocessor.Repo]

config :nx, default_backend: EXLA.Backend
