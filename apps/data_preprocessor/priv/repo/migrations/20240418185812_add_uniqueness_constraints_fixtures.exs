defmodule DataPreprocessor.Repo.Migrations.AddUniquenessConstraintsFixtures do
  use Ecto.Migration

  def change do
    create unique_index(:fixtures, [:season, :league, :date, :home_team_id, :away_team_id])
  end
end
