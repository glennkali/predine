defmodule DataPreprocessor.Ranker do
  require Logger
  require Ecto.Query
  use Timex

  def rank(country, season, league) do
    DataPreprocessor.Repo.transaction(fn ->
      initialize_team_statistics(country, season, league)
      rank_teams(season, league)
    end)
  end

  defp initialize_team_statistics(country, season, league) do
    DataPreprocessor.Team
    |> Ecto.Query.where(country: ^String.capitalize(country))
    |> DataPreprocessor.Repo.all
    |> Enum.each(&persist_initial_team_statistic(season, league, &1))
  end

  defp persist_initial_team_statistic(season, league, team) do
    team
    |> Ecto.build_assoc(:team_statistics)
    |> DataPreprocessor.TeamStatistic.changeset(%{season: season, league: league})
    |> DataPreprocessor.Repo.insert(mode: :savepoint)
    |> case do
      {:ok, team_statistic} ->
        Logger.info("Successfully initialized stats for #{inspect team}  to the database, id: #{team_statistic.id}")
      {:error, changeset} ->
        Logger.error("An error occurred when creating stat event: #{inspect changeset.errors}")
    end
  end

  def rank_teams(season, league) do
    DataPreprocessor.Fixture
    |> Ecto.Query.where([season: ^season, league: ^league])
    |> Ecto.Query.order_by(asc: :date)
    |> DataPreprocessor.Repo.all
    |> Enum.each(&update_rankings_for(season, league, &1))
  end

  def update_rankings_for(season, league, fixture) do
    home_team_stat = DataPreprocessor.TeamStatistic
    |> DataPreprocessor.Repo.get_by([team_id:  fixture.home_team_id, season: season, league: league])

    away_team_stat = DataPreprocessor.TeamStatistic
    |> DataPreprocessor.Repo.get_by([team_id:  fixture.away_team_id, season: season, league: league])

    calculate_rating(fixture, home_team_stat, away_team_stat)
    |> case do
      [home_new_rating, away_new_rating] ->
        create_team_statistic_event(fixture, league, home_team_stat, home_new_rating)
        create_team_statistic_event(fixture, league, away_team_stat, away_new_rating)
    end
  end

  defp create_team_statistic_event(fixture, league, team_stat, new_rating) do
    team_stat
    |> Ecto.build_assoc(:team_statistic_events)
    |> DataPreprocessor.TeamStatisticEvent.changeset(%{fixture_id: fixture.id, old_rating: team_stat.rating, new_rating: new_rating})
    |> DataPreprocessor.Repo.insert(mode: :savepoint)
    |> case do
      {:ok, t_s_e} ->
        Logger.info("Successfully created stat event for #{inspect fixture}  to the database, id: #{t_s_e.id}")
        update_team_statistics(fixture, league, team_stat, new_rating)
      {:error, changeset} -> Logger.error("An error occurred when creating stat event: #{inspect changeset.errors}")
    end
  end

  defp update_team_statistics(fixture, league, team_stat, new_rating) do
    {:ok, _updated_team_stat} = team_stat
    |> DataPreprocessor.TeamStatistic.changeset(
      %{
        rating: new_rating,
        fixtures_played: team_stat.fixtures_played + 1,
        goals_scored_home: team_stat.goals_scored_home + fixture.full_time_home_goals,
        goals_conceided_home: team_stat.goals_conceided_home + fixture.full_time_away_goals,
        league: league,
      }
    )
    |> DataPreprocessor.Repo.update
  end

  defp calculate_rating(fixture, home_stat, away_stat) do
    home_old_rating = home_stat.rating
    away_old_rating = away_stat.rating

    home_pot_contribution = 0.07 * home_old_rating
    away_pot_contribution = 0.05 * away_old_rating

    case fixture.full_time_result do
      "H" ->
        [home_old_rating + away_pot_contribution, away_old_rating - away_pot_contribution]
      "D" ->
        [home_old_rating - home_pot_contribution + away_pot_contribution, away_old_rating + home_pot_contribution - away_pot_contribution]
      "A" ->
        [home_old_rating - home_pot_contribution, away_old_rating + home_pot_contribution]
    end
  end
end
