defmodule Hangman.Impl.Game do
  alias Hangman.Type
  # This structure has the same name as the module it is in.
  @type t :: %__MODULE__{
          turns_left: integer,
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  ################################################################

  @spec new_game :: t
  def new_game do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    %__MODULE__{
      letters: word |> String.codepoints()
    }
  end

  ################################################################

  @spec make_move(t, String.t()) :: {t, Type.tally()}
  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game |> return_with_tally()
  end

  def make_move(game, guess) do
    maybe_move(game, guess, guess |> valid?()) |> return_with_tally()
  end

  defp maybe_move(game, guess, true) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
  end

  defp maybe_move(game, _guess, false), do: game

  ################################################################

  defp accept_guess(game, _guess, _already_used = true) do
    # Returns the identical game object, except the game_state field is changed to the `already_used` atom.
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _already_used) do
    # Returns the identical game object, except the game_state field is changed to the `already_used` atom.
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(game.letters |> Enum.member?(guess))
  end

  ################################################################

  defp score_guess(game, _good_guess = true) do
    new_state = maybe_won(MapSet.new(game.letters) |> MapSet.subset?(game.used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turns_left: 1}, _bad_guess) do
    %{game | game_state: :lost, turns_left: 0}
  end

  defp score_guess(game, _bad_guess) do
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  ################################################################

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  defp reveal_guessed_letters(game = %{game_state: :lost}) do
    game.letters
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess

  defp maybe_reveal(true, letter), do: letter
  defp maybe_reveal(_, _letter), do: "_"

  # returns true if the string passed in is a lower case ascii in range a..=z and is single letter
  defp valid?(guess) do
    String.length(guess) == 1 && lowercase?(guess)
  end

  defp lowercase?(guess) do
    <<c::utf8>> = guess
    97 <= c && c <= 122
  end
end
