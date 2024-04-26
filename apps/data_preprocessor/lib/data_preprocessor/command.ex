defmodule DataPreprocessor.Command do
  def parse(line) do
    case String.split(line) do
      ["INITIALIZE", country, season] -> {:ok, {:initialize, country, season}}
      ["INITIALIZE", season] -> {:ok, {:initialize, season}}
      ["INITIALIZE"] -> {:ok, {:initialize}}
      ["RANK", country, season, league] -> {:ok, {:rank, country, season, league}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Runs the given command.
  """
  def run(command)

  def run({:initialize, country, season}) do
    {:ok, _pid} =
      Task.Supervisor.start_child(DataPreprocessor.TaskSupervisor, fn ->
        DataPreprocessor.Initializer.init(country, season)
      end)

    {:ok, "STARTED - #{country} #{season} Initialization\r\n"}
  end

  def run({:initialize, season}) do
    {:ok, _pid} =
      Task.Supervisor.start_child(DataPreprocessor.TaskSupervisor, fn ->
        DataPreprocessor.Initializer.init(season)
      end)

    {:ok, "STARTED - #{season} Initialization\r\n"}
  end

  def run({:initialize}) do
    {:ok, _pid} =
      Task.Supervisor.start_child(DataPreprocessor.TaskSupervisor, fn ->
        DataPreprocessor.Initializer.init()
      end)

    {:ok, "STARTED - Global Initialization\r\n"}
  end

  def run({:rank, country, season, league}) do
    {:ok, _pid} =
      Task.Supervisor.start_child(DataPreprocessor.TaskSupervisor, fn ->
        DataPreprocessor.Ranker.rank(country, season, league)
      end)

    {:ok, "STARTED - Ranking campaign #{country}_#{season}_#{league}\r\n"}
  end
end
