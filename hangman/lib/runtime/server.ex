# This GenServer runs in its own process and maintains its own state internally.
defmodule Hangman.Runtime.Server do
  @type t :: pid

  alias Hangman.Impl.Game

  # This defines many seperate functions.
  # 9 seperate callbacks would have to have handlers for it to compile without this behavior.
  use GenServer

  # Client process
  def start_link(_) do
    # Takes tke module that will be the GenServer, and then arguments

    GenServer.start_link(__MODULE__, nil)
  end

  # Server process

  @spec init(any) :: {:ok, Game.t()}
  def init(_) do
    # State of the server when it first starts up.
    {:ok, Game.new_game()}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {updated_game, tally} = Game.make_move(game, guess)
    {:reply, tally, updated_game}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Game.tally(game), game}
  end
end
