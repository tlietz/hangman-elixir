defmodule GameImplGameTest do
  use ExUnit.Case
  doctest Hangman

  alias Hangman.Impl.Game

  test "new game returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns correct word" do
    game = Game.new_game("wombat")

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["w", "o", "m", "b", "a", "t"]
  end

  test "new game returns lowercase letters" do
    game = Game.new_game("abcdefghijklmnopqrstuvwxyz")

    assert game.letters |> lowercase?()
  end

  def lowercase?([h | t]) do
    [c] = h |> to_charlist()

    if c < 97 || c > 122 do
      false
    else
      t |> lowercase?()
    end
  end

  def lowercase?([]) do
    true
  end
end
