defmodule Hangman.Runtime.Application do
  # Loads defaults into this module
  use Application

  @super_name GameStarter

  # This is a callback function that is required in the module that starts the application.
  # The function is invoked automatically by the runtime as long as
  # we register the entry point module in `mix.exs`
  #
  # The job of the `start` function is to return the top level process.
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    supervisor_spec = [
      {DynamicSupervisor, strategy: :one_for_one, name: @super_name}
    ]

    # Now this supervisor will restart the dictionary by calling its `start_link` function
    Supervisor.start_link(supervisor_spec, strategy: :one_for_one)
  end

  def start_game do
    DynamicSupervisor.start_child(@super_name, {Hangman.Runtime.Server, nil})
  end
end
