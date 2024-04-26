defmodule DataPreprocessor.Repo.Migrations.CreateTeamStatistics do
  use Ecto.Migration

  def change do
    create table(:team_statistics) do
      add :season, :string
      add :team_id, references(:teams)
      add :rating, :float
      add :fixtures_played, :integer
      add :goals_scored_home, :integer
      add :goals_scored_away, :integer
      add :goals_conceided_home, :integer
      add :goals_conceided_away, :integer
      timestamps()
    end
  end
end
