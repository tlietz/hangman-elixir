defmodule Hangman.Type do
  # state mimics the functionality of an Enum by having all of the atoms that state could be.
  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used

  @type tally :: %{
          turns_left: integer,
          game_state: state,
          letters: list(String.t()),
          used: list(String.t())
        }
end
