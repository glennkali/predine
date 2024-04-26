defmodule DataPreprocessor.Repo.Migrations.CreateFixtures do
  use Ecto.Migration

  def change do
    create table(:fixtures) do
      add :season, :string
      add :division, :string
      add :date, :utc_datetime
      add :home_team_id, references(:teams)
      add :away_team_id, references(:teams)
      add :full_time_home_goals, :integer
      add :full_time_away_goals, :integer
      add :full_time_result, :string
      add :half_time_home_goals, :integer
      add :half_time_away_goals, :integer
      add :half_time_result, :string
      add :odds_home_bet365, :float
      add :odds_draw_bet365, :float
      add :odds_away_bet365, :float
      add :odds_home_betwin, :float
      add :odds_draw_betwin, :float
      add :odds_away_betwin, :float
      add :odds_home_gamebookers, :float
      add :odds_draw_gamebookers, :float
      add :odds_away_gamebookers, :float
      add :odds_home_interwetten, :float
      add :odds_draw_interwetten, :float
      add :odds_away_interwetten, :float
      add :odds_home_ladbrokes, :float
      add :odds_draw_ladbrokes, :float
      add :odds_away_ladbrokes, :float
      add :odds_home_sportingbet, :float
      add :odds_draw_sportingbet, :float
      add :odds_away_sportingbet, :float
      add :odds_home_willhill, :float
      add :odds_draw_willhill, :float
      add :odds_away_willhill, :float
      add :odds_home_stanjames, :float
      add :odds_draw_stanjames, :float
      add :odds_away_stanjames, :float
      add :odds_home_vcbet, :float
      add :odds_draw_vcbet, :float
      add :odds_away_vcbet, :float
    end
  end
end
