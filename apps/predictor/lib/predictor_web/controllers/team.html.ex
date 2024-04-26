defmodule PredictorWeb.TeamHTML do
  use PredictorWeb, :html

  embed_templates("team_html/*")

  attr(:id, :string, required: true)

  def show_team(assigns) do
    ~H"""
      <h2>Hello World, from <%= @id %>!</h2>
    """
  end

  attr(:payload, :list, required: true)

  def list_teams(assigns) do
    ~H"""
    <table class="table">
      <thead>
      <tr>
        <th>Id</th>
        <th>Name</th>
        <th>Country</th>
        <th>Season</th>
        <th>League</th>
        <th>Rating</th>
      </tr>
      </thead>
      <tr :for={team <- @payload}>
        <tr :for={rating <- team.rating}>
          <th><%= team.id %></th>
          <th><%= team.name %></th>
          <th><%= team.country %></th>
          <th><%= rating.season %></th>
          <th><%= rating.league %></th>
          <th><%= rating.rating %></th>
        </tr>
      </tr>
    </table>
    """
  end
end
