defmodule Hangman do
  # Automatically aliases `Hangman.Impl.Game` to `Game`
  alias Hangman.Impl.Game
  alias Hangman.Type
  # Opaque defines a type that cannot be accessed outside this module
  @opaque game :: Game.t()

  @spec new_game :: Game.t()
  defdelegate new_game, to: Game
  # def new_game do
  #   Game.new_game()
  # end

  @spec make_move(game, String.t()) :: {game, Type.tally()}
  defdelegate make_move(game, guess), to: Game

  @spec tally(game) :: Type.tally()
  defdelegate tally(game), to: Game
end
