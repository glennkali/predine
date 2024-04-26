defmodule DataPreprocessor.TeamStatistic do
  use Ecto.Schema

  schema "team_statistics" do
    field :season, :string
    field :league, :string
    field :rating, :float, default: 1000.0
    field :fixtures_played, :integer, default: 0
    field :goals_scored_home, :integer, default: 0
    field :goals_scored_away, :integer, default: 0
    field :goals_conceided_home, :integer, default: 0
    field :goals_conceided_away, :integer, default: 0

    belongs_to :team, DataPreprocessor.Team
    has_many :team_statistic_events, DataPreprocessor.TeamStatisticEvent
    timestamps(type: :utc_datetime)
  end

  def changeset(team_statistic, params \\ %{}) do
    team_statistic
    |> Ecto.Changeset.cast(params, [:season, :league, :rating, :fixtures_played, :goals_scored_home, :goals_scored_away, :goals_conceided_home, :goals_conceided_away])
    |> Ecto.Changeset.validate_required([:season, :league, :rating])
    |> Ecto.Changeset.unique_constraint([:team_id, :season, :league], name: :team_statistics_team_id_season_league_index)
  end
end
