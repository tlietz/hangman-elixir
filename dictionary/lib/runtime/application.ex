defmodule Dictionary.Runtime.Application do
  # Loads defaults into this module
  use Application

  # This is a callback function that is required in the module that starts the application.
  # The function is invoked automatically by the runtime as long as
  # we register the entry point module in `mix.exs`
  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    Dictionary.Runtime.Server.start_link()
  end
end
