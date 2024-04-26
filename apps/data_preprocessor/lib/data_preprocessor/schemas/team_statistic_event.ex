defmodule DataPreprocessor.TeamStatisticEvent do
  use Ecto.Schema

  schema "team_statistic_events" do
    field :fixture_id, :integer
    field :old_rating, :float
    field :new_rating, :float

    belongs_to :team_statistic, DataPreprocessor.TeamStatistic
    timestamps(type: :utc_datetime)
  end

  def changeset(team_statistic_event, params \\ %{}) do
    team_statistic_event
    |> Ecto.Changeset.cast(params, [:fixture_id, :old_rating, :new_rating])
    |> Ecto.Changeset.validate_required([:fixture_id, :old_rating, :new_rating])
    |> Ecto.Changeset.unique_constraint([:fixture_id, :team_statistic_id], name: :team_statistic_events_team_statistic_id_fixture_id_index)
  end
end
