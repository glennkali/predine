defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsEventCascadeDelete do
  use Ecto.Migration

  def change do
    alter table(:team_statistic_events) do
      remove :team_statistic_id, references(:team_statistics)
      add :team_statistic_id, references(:team_statistics, on_delete: :delete_all)
    end
  end
end
