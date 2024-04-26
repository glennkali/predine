defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsEventId do
  use Ecto.Migration

  def change do
    alter table(:team_statistic_events) do
      remove :team_statistics_id, references(:team_statistics)
      add :team_statistic_id, references(:team_statistics)
    end
  end
end
