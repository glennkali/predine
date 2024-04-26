defmodule DataPreprocessor.Application do
  use Application

  @impl true
  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT") || "4040")

    children = [
      DataPreprocessor.Repo,
      {Task.Supervisor, name: DataPreprocessor.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> DataPreprocessor.accept(port) end}, restart: :permanent)
    ]

    opts = [strategy: :one_for_all, name: DataPreprocessor.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
