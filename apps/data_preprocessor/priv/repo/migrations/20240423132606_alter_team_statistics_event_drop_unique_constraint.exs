defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsEventDropUniqueConstraint do
  use Ecto.Migration

  def change do
    drop unique_index(:team_statistics, [:team_id, :season, :league, :fixtures_played])
    create unique_index(:team_statistics, [:team_id, :season, :league])
  end
end
