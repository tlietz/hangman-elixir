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

  test "state doesn't change if a game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "we record letters used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    {game, _tally} = Game.make_move(game, "x")
    assert MapSet.equal?(game.used, MapSet.new(["x", "y"]))
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "o")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new_game("wombat")
    {_game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
  end

  test "can handle a sequence of moves" do
    [
      # guess  state   turns     letters              used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["x", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "x"]]
    ]
    |> test_sequence_of_moves()
  end

  def test_sequence_of_moves(script) do
    game = Game.new_game("hello")
    Enum.reduce(script, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)

    assert tally.game_state == state
    assert tally.turns_left == turns
    assert tally.letters == letters
    assert tally.used == used

    game
  end

  test "can validate guess is a single lowercase ASCII character" do
    game = Game.new_game()
    {game, tally} = Game.make_move(game, "aa")
    assert tally.turns_left == 7
    assert tally.game_state == :initializing
    {game, tally} = Game.make_move(game, "aaaa")
    assert tally.turns_left == 7
    assert tally.game_state == :initializing
    {game, tally} = Game.make_move(game, "ZZZZ")
    assert tally.turns_left == 7
    assert tally.game_state == :initializing
    {game, tally} = Game.make_move(game, "ZZ˙ƒ∂ZZ")
    assert tally.turns_left == 7
    assert tally.game_state == :initializing
    {_game, tally} = Game.make_move(game, "a")
    assert tally.game_state != :initializing
  end

  test "new game returns lowercase letters" do
    game = Game.new_game("abcdefghijklmnopqrstuvwxyz")

    assert game.letters |> lowercase?()
  end

  defp lowercase?([]) do
    true
  end

  defp lowercase?([h | t]) do
    [c] = h |> to_charlist()

    if c < 97 || c > 122 do
      false
    else
      t |> lowercase?()
    end
  end
end
