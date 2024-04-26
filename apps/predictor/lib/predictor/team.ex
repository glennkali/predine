defmodule Predictor.Team do
  import Ecto.Query, warn: false
  alias DataPreprocessor.Repo
  alias DataPreprocessor.Team
  alias DataPreprocessor.TeamStatistic

  def get_teams(_params) do
    DataPreprocessor.Repo.transaction(fn ->
      Team
      |> order_by(asc: :id)
      |> Repo.stream()
      |> Enum.map(fn x -> convert_to_json(x) end)
    end)
  end

  defp convert_to_json(record) do
    %{
      id: record.id,
      name: record.name,
      country: record.country,
      rating: load_statistic(record)
    }
  end

  def load_statistic(record) do
    query =
      from(TeamStatistic,
        where: [team_id: ^record.id],
        select: [:season, :league, :rating]
      )

    Repo.all(query)
    |> Enum.map(fn x ->
      %{
        season: x.season,
        league: x.league,
        rating: x.rating
      }
    end)
  end
end
