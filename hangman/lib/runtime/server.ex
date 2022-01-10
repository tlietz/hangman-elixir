# This GenServer runs in its own process and maintains its own state internally.
defmodule Hangman.Runtime.Server do
  @type t :: pid

  # 1 hour
  @idle_timeout 1 * 60 * 60 * 1000

  alias Hangman.Impl.Game
  alias Hangman.Runtime.Watchdog

  # This defines many seperate functions.
  # 9 seperate callbacks would have to have handlers for it to compile without this behavior.
  use GenServer

  # Client process
  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    # Takes tke module that will be the GenServer, and then arguments
    GenServer.start_link(__MODULE__, nil)
  end

  # Server process

  @spec init(any) :: {:ok, {Hangman.Impl.Game.t(), any}}
  def init(_) do
    # State of the server when it first starts up.
    watcher = Watchdog.start(@idle_timeout)
    {:ok, {Game.new_game(), watcher}}
  end

  def handle_call({:make_move, guess}, _from, {game, watcher}) do
    Watchdog.im_alive(watcher)
    {updated_game, tally} = Game.make_move(game, guess)
    {:reply, tally, {updated_game, watcher}}
  end

  def handle_call({:tally}, _from, {game, watcher}) do
    Watchdog.im_alive(watcher)
    {:reply, Game.tally(game), {game, watcher}}
  end
end
