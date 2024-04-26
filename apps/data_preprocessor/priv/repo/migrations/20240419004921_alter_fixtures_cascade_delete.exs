defmodule DataPreprocessor.Repo.Migrations.AlterFixturesCascadeDelete do
  use Ecto.Migration

  def change do
    execute "ALTER TABLE fixtures DROP CONSTRAINT fixtures_home_team_id_fkey"
    execute "ALTER TABLE fixtures DROP CONSTRAINT fixtures_away_team_id_fkey"
    alter table(:fixtures) do
      modify :home_team_id, references(:teams, on_delete: :delete_all)
      modify :away_team_id, references(:teams, on_delete: :delete_all)
    end
  end
end
