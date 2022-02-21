defmodule Hangman do
  alias Hangman.Runtime.Server
  alias Hangman.Type
  # Opaque defines a type that cannot be accessed outside this module
  @opaque game :: Server.t()

  @spec new_game :: Game.t()
  def new_game do
    {:ok, pid} = Hangman.Runtime.Application.start_game()
    pid
  end

  @spec make_move(game, String.t()) :: Type.tally()
  def make_move(game, guess) do
    GenServer.call(game, {:make_move, guess})
  end

  @spec tally(game) :: Type.tally()
  def tally(game) do
    GenServer.call(game, {:tally})
  end
end
