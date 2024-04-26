defmodule DataPreprocessor.Repo.Migrations.AddUniquenessConstraintsOnFixtures do
  use Ecto.Migration

  def change do
    create unique_index(:fixtures, [:home_team_id, :away_team_id, :season, :date])
  end
end
