defmodule DataPreprocessor.Repo.Migrations.AddCountryToTeam do
  use Ecto.Migration

  def change do
    alter table(:teams) do
      add :country, :string
    end
  end
end
