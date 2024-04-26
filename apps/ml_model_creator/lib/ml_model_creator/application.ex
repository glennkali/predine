defmodule MlModelCreator.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: MlModelCreator.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> MlModelCreator.create() end}, restart: :temporary)
    ]

    opts = [strategy: :one_for_all, name: MlModelCreator.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
