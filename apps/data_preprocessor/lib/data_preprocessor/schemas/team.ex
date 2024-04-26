defmodule DataPreprocessor.Team do
  use Ecto.Schema

  schema "teams" do
    field :name, :string
    field :country, :string
    has_many :team_statistics, DataPreprocessor.TeamStatistic

    timestamps(type: :utc_datetime)
  end

  def changeset(team, params \\ %{}) do
    team
    |> Ecto.Changeset.cast(params, [:name, :country])
    |> Ecto.Changeset.validate_required([:name, :country])
    |> Ecto.Changeset.unique_constraint([:name, :country])
  end
end
