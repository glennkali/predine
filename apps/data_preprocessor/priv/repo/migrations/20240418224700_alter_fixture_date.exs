defmodule DataPreprocessor.Repo.Migrations.AlterFixtureDate do
  use Ecto.Migration

  def change do
    alter table(:fixtures) do
      remove :date, :utc_datetime
      add :date, :date
    end
  end
end
