defmodule Ozzy do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Ozzy.Worker.start_link(arg1, arg2, arg3)
      # worker(Ozzy.Worker, [arg1, arg2, arg3]),
      worker(Ozzy.Brain, []),
      worker(Slack.Bot, [Ozzy.Bot, [], Application.get_env(:slack, :api_token)])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ozzy.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
