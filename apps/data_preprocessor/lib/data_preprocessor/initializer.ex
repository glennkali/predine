defmodule DataPreprocessor.Initializer do
  require Explorer.DataFrame
  require Logger
  use Timex

  def init() do
    seasons()
    |> Enum.each(&init(&1))
  end

  def init(season) do
    leagues()
    |> Enum.each(fn {country, leagues} ->
      leagues
      |> Enum.each(&import_campaign_data(country, season, &1))
    end)
  end

  def init(country, season) do
    leagues()
    |> Map.get(country)
    |> Enum.each(&import_campaign_data(country, season, &1))
  end

  defp import_campaign_data(country, season, league) do
    df =
      Explorer.DataFrame.from_csv!(
        Application.app_dir(:data_preprocessor, "priv/data/#{season}/#{league}.csv")
      )

    DataPreprocessor.Repo.transaction(fn ->
      import_teams(country, df)
      import_fixtures(season, df)
    end)
  end

  defp import_teams(country, df) do
    cols = Explorer.DataFrame.to_columns(df)
    home_teams = cols[Enum.at(columns(), 2)]
    away_teams = cols[Enum.at(columns(), 3)]

    Enum.concat(home_teams, away_teams)
    |> Enum.uniq()
    |> Enum.each(&persist_team(country, &1))
  end

  defp persist_team(country, team_name) do
    %DataPreprocessor.Team{}
    |> DataPreprocessor.Team.changeset(%{name: team_name, country: String.capitalize(country)})
    |> DataPreprocessor.Repo.insert(on_conflict: :nothing, conflict_target: :name)
    |> case do
      {:ok, team_record} ->
        Logger.info(
          "Successfully added #{team_name} from #{country} to the database, id: #{team_record.id}"
        )

      {:error, changeset} ->
        Logger.error("An error occurred when inserting #{team_name} : #{inspect(changeset)}")
    end
  end

  def import_fixtures(season, df) do
    Explorer.DataFrame.to_rows(df)
    |> Enum.each(&persist_fixture(season, &1))
  end

  defp persist_fixture(season, row) do
    home_team =
      DataPreprocessor.Team
      |> DataPreprocessor.Repo.get_by(name: Map.get(row, Enum.at(columns(), 2)))

    away_team =
      DataPreprocessor.Team
      |> DataPreprocessor.Repo.get_by(name: Map.get(row, Enum.at(columns(), 3)))

    date =
      Map.get(row, Enum.at(columns(), 1))
      |> String.split("/")
      |> List.to_tuple()
      |> format_date_tuple()
      |> Timex.to_date()

    %DataPreprocessor.Fixture{}
    |> DataPreprocessor.Fixture.changeset(%{
      home_team_id: home_team.id,
      away_team_id: away_team.id,
      season: season,
      league: Map.get(row, Enum.at(columns(), 0)),
      date: date,
      full_time_home_goals: Map.get(row, Enum.at(columns(), 4)),
      full_time_away_goals: Map.get(row, Enum.at(columns(), 5)),
      full_time_result: Map.get(row, Enum.at(columns(), 6)),
      half_time_home_goals: Map.get(row, Enum.at(columns(), 7)),
      half_time_away_goals: Map.get(row, Enum.at(columns(), 8)),
      half_time_result: Map.get(row, Enum.at(columns(), 9)),
      odds_home_bet365: Map.get(row, Enum.at(columns(), 10)),
      odds_draw_bet365: Map.get(row, Enum.at(columns(), 11)),
      odds_away_bet365: Map.get(row, Enum.at(columns(), 12)),
      odds_home_betwin: Map.get(row, Enum.at(columns(), 13)),
      odds_draw_betwin: Map.get(row, Enum.at(columns(), 14)),
      odds_away_betwin: Map.get(row, Enum.at(columns(), 15)),
      odds_home_gamebookers: Map.get(row, Enum.at(columns(), 16)),
      odds_draw_gamebookers: Map.get(row, Enum.at(columns(), 17)),
      odds_away_gamebookers: Map.get(row, Enum.at(columns(), 18)),
      odds_home_interwetten: Map.get(row, Enum.at(columns(), 19)),
      odds_draw_interwetten: Map.get(row, Enum.at(columns(), 20)),
      odds_away_interwetten: Map.get(row, Enum.at(columns(), 21)),
      odds_home_ladbrokes: Map.get(row, Enum.at(columns(), 21)),
      odds_draw_ladbrokes: Map.get(row, Enum.at(columns(), 22)),
      odds_away_ladbrokes: Map.get(row, Enum.at(columns(), 23)),
      odds_home_sportingbet: Map.get(row, Enum.at(columns(), 24)),
      odds_draw_sportingbet: Map.get(row, Enum.at(columns(), 25)),
      odds_away_sportingbet: Map.get(row, Enum.at(columns(), 26)),
      odds_home_willhill: Map.get(row, Enum.at(columns(), 27)),
      odds_draw_willhill: Map.get(row, Enum.at(columns(), 28)),
      odds_away_willhill: Map.get(row, Enum.at(columns(), 29)),
      odds_home_stanjames: Map.get(row, Enum.at(columns(), 30)),
      odds_draw_stanjames: Map.get(row, Enum.at(columns(), 31)),
      odds_away_stanjames: Map.get(row, Enum.at(columns(), 32)),
      odds_home_vcbet: Map.get(row, Enum.at(columns(), 33)),
      odds_draw_vcbet: Map.get(row, Enum.at(columns(), 34)),
      odds_away_vcbet: Map.get(row, Enum.at(columns(), 35))
    })
    |> DataPreprocessor.Repo.insert(
      on_conflict: :nothing,
      conflict_target: [:home_team_id, :away_team_id, :season, :date]
    )
    |> case do
      {:ok, fixture_record} ->
        Logger.info("Successfully added fixture #{fixture_record.id} to the database.")

      {:error, changeset} ->
        Logger.error("An error occurred: #{inspect(changeset)}")
    end
  end

  defp seasons do
    [
      "2013-2014",
      "2014-2015",
      "2015-2016",
      "2016-2017",
      "2017-2018",
      "2018-2019",
      "2019-2020",
      "2020-2021",
      "2021-2022",
      "2022-2023",
      "2023-2024"
    ]
  end

  defp leagues do
    %{
      "england" => ["E0", "E1", "E2", "E3", "EC"],
      "scotland" => ["SC0", "SC1", "SC2", "SC3"],
      "germany" => ["D1", "D2"],
      "italy" => ["I1", "I2"],
      "spain" => ["SP1", "SP2"],
      "france" => ["F1", "F2"],
      "netherlands" => ["N1"],
      "belgium" => ["B1"],
      "portugal" => ["P1"],
      "turkey" => ["T1"],
      "greece" => ["G1"]
    }
  end

  defp columns do
    [
      "Div",
      "Date",
      "HomeTeam",
      "AwayTeam",
      "FTHG",
      "FTAG",
      "FTR",
      "HTHG",
      "HTAG",
      "HTR",
      "B365H",
      "B365D",
      "B365A",
      "BWH",
      "BWD",
      "BWA",
      "IWH",
      "IWD",
      "IWA",
      "LBH",
      "LBD",
      "LBA",
      "PSH",
      "PSD",
      "PSA",
      "WHH",
      "WHD",
      "WHA",
      "SJH",
      "SJD",
      "SJA",
      "VCH",
      "VCD",
      "VCA",
      "Bb1X2",
      "BbMxH",
      "BbAvH",
      "BbMxD",
      "BbAvD",
      "BbMxA",
      "BbAvA",
      "BbOU",
      "BbMx>2.5",
      "BbAv>2.5",
      "BbMx<2.5",
      "BbAv<2.5",
      "BbAH",
      "BbAHh",
      "BbMxAHH",
      "BbAvAHH",
      "BbMxAHA",
      "BbAvAHA",
      "PSCH",
      "PSCD",
      "PSCA"
    ]
  end

  defp format_date_tuple(date_tuple) do
    day = Kernel.elem(date_tuple, 0) |> String.to_integer()
    month = Kernel.elem(date_tuple, 1) |> String.to_integer()

    year = Kernel.elem(date_tuple, 2)

    year =
      if String.length(year) == 2 do
        "20#{year}"
      else
        year
      end
      |> String.to_integer()

    {year, month, day}
  end
end
