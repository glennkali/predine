defmodule FineTuner.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Task.Supervisor, name: FineTuner.TaskSupervisor},
      Supervisor.child_spec({Task, fn -> FineTuner.create_model() end}, restart: :permanent),
    ]

    opts = [strategy: :one_for_one, name: FineTuner.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
