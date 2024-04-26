defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsEventTeamStatisticNotNull do
  use Ecto.Migration

  def change do
    alter table(:team_statistic_events) do
      remove :team_statistic_id, references(:team_statistics, on_delete: :delete_all)
      add :team_statistic_id, references(:team_statistics, on_delete: :delete_all), null: false
    end
  end
end
