defmodule Dictionary.Runtime.Application do
  # Loads defaults into this module
  use Application

  # This is a callback function that is required in the module that starts the application.
  # The function is invoked automatically by the runtime as long as
  # we register the entry point module in `mix.exs`
  #
  # The job of the `start` function is to return the top level process.
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      # {child module, list of parameters}
      {Dictionary.Runtime.Server, []}
    ]

    options = [
      name: Dictionary.Runtime.Supervisor,
      strategy: :one_for_one,
      max_restarts: 10
    ]

    # Now this supervisor will restart the dictionary by calling its `start_link` function
    Supervisor.start_link(children, options)
  end
end
