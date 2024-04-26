defmodule DataPreprocessor.Fixture do
  use Ecto.Schema

  schema "fixtures" do
    field :home_team_id, :integer
    field :away_team_id, :integer
    field :season, :string
    field :league, :string
    field :date, :date
    field :full_time_home_goals, :integer
    field :full_time_away_goals, :integer
    field :full_time_result, :string
    field :half_time_home_goals, :integer
    field :half_time_away_goals, :integer
    field :half_time_result, :string
    field :odds_home_bet365, :float
    field :odds_draw_bet365, :float
    field :odds_away_bet365, :float
    field :odds_home_betwin, :float
    field :odds_draw_betwin, :float
    field :odds_away_betwin, :float
    field :odds_home_gamebookers, :float
    field :odds_draw_gamebookers, :float
    field :odds_away_gamebookers, :float
    field :odds_home_interwetten, :float
    field :odds_draw_interwetten, :float
    field :odds_away_interwetten, :float
    field :odds_home_ladbrokes, :float
    field :odds_draw_ladbrokes, :float
    field :odds_away_ladbrokes, :float
    field :odds_home_sportingbet, :float
    field :odds_draw_sportingbet, :float
    field :odds_away_sportingbet, :float
    field :odds_home_willhill, :float
    field :odds_draw_willhill, :float
    field :odds_away_willhill, :float
    field :odds_home_stanjames, :float
    field :odds_draw_stanjames, :float
    field :odds_away_stanjames, :float
    field :odds_home_vcbet, :float
    field :odds_draw_vcbet, :float
    field :odds_away_vcbet, :float
  end

  def changeset(fixture, params \\ %{}) do
    fixture
    |> Ecto.Changeset.cast(params, [:home_team_id, :away_team_id, :season, :league, :date, :full_time_home_goals, :full_time_away_goals, :full_time_result, :half_time_home_goals, :half_time_away_goals, :half_time_result, :odds_home_bet365, :odds_draw_bet365, :odds_away_bet365, :odds_home_betwin, :odds_draw_betwin, :odds_away_betwin, :odds_home_gamebookers, :odds_draw_gamebookers, :odds_away_gamebookers, :odds_home_interwetten, :odds_draw_interwetten, :odds_away_interwetten, :odds_home_ladbrokes, :odds_draw_ladbrokes, :odds_away_ladbrokes, :odds_home_sportingbet, :odds_draw_sportingbet, :odds_away_sportingbet, :odds_home_willhill, :odds_draw_willhill, :odds_away_willhill, :odds_home_stanjames, :odds_draw_stanjames, :odds_away_stanjames, :odds_home_vcbet, :odds_draw_vcbet, :odds_away_vcbet])
    |> Ecto.Changeset.validate_required([:home_team_id, :away_team_id, :season, :date, :full_time_home_goals, :full_time_away_goals, :full_time_result])
    |> Ecto.Changeset.unique_constraint([:season, :league, :date, :home_team_id, :away_team_id])
  end
end
