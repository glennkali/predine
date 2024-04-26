defmodule PredictorWeb.TeamController do
  use PredictorWeb, :controller
  alias Predictor.Team

  def index(conn, params) do
    {:ok, stream_of_teams} = Team.get_teams(params)
    render(conn, "index.html", payload: stream_of_teams)
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", id: id)
  end
end
