defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsDropUniqueConstraints do
  use Ecto.Migration

  def change do
    drop unique_index(:team_statistics, [:team_id, :season])
    drop unique_index(:team_statistics, [:team_id, :season, :fixtures_played])
  end
end
