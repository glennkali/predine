defmodule DataPreprocessor.Repo.Migrations.AddUniquenessConstraintTeamstatistic do
  use Ecto.Migration

  def change do
    create unique_index(:team_statistics, [:team_id, :season, :fixtures_played])
  end
end
