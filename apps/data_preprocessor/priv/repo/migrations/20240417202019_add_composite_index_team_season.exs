defmodule DataPreprocessor.Repo.Migrations.AddCompositeIndexTeamSeason do
  use Ecto.Migration

  def change do
    create index(:team_statistics, [:team_id, :season])
  end
end
