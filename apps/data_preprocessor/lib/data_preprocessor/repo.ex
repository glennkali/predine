defmodule DataPreprocessor.Repo do
  use Ecto.Repo,
    otp_app: :data_preprocessor,
    adapter: Ecto.Adapters.Postgres
end
