defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsEventUnique do
  use Ecto.Migration

  def change do
    create unique_index(:team_statistic_events, [:team_statistic_id, :fixture_id])
  end
end
