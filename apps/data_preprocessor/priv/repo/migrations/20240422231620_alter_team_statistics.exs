defmodule DataPreprocessor.Repo.Migrations.AlterTeamStatistics do
  use Ecto.Migration

  def change do
    alter table(:team_statistics) do
      add :league, :string
    end
  end
end
