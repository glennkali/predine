defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatisticsEvent do
  use Ecto.Migration

  def change do
    alter table(:team_statistic_events) do
      remove :home_team_statistics_id, references(:team_statistics)
      add :team_statistics_id, references(:team_statistics)
      remove :home_team_old_rating, :float
      add :old_rating, :float
      remove :home_team_new_rating, :float
      add :new_rating, :float
      remove :away_team_statistics_id, references(:team_statistics)
      remove :away_team_old_rating, :float
      remove :away_team_new_rating, :float
    end
  end
end
