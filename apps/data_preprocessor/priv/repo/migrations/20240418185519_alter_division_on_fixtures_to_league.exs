defmodule DataPreprocessor.Repo.Migrations.AlterDivisionOnFixturesToLeague do
  use Ecto.Migration

  def change do
    alter table(:fixtures) do
      remove :division, :string
      add :league, :string
    end
  end
end
