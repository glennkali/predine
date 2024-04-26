defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsUniqueness do
  use Ecto.Migration

  def change do
    create unique_index(:team_statistics, [:team_id, :season, :league, :fixtures_played])
  end
end
