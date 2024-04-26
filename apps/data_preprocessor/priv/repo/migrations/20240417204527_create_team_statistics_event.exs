defmodule DataPreprocessor.Repo.Migrations.CreateTeamStatisticsEvent do
  use Ecto.Migration

  def change do
    create table(:team_statistic_events) do
      add :fixture_id, references(:fixtures)
      add :home_team_statistics_id, references(:team_statistics)
      add :home_team_old_rating, :float
      add :home_team_new_rating, :float
      add :away_team_statistics_id, references(:team_statistics)
      add :away_team_old_rating, :float
      add :away_team_new_rating, :float
      timestamps()
    end
  end
end
