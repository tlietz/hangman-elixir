# Module names must be an Elixir Atom. Conventionally with CapitalizedWords.
defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dictionary.hello()
      :world

  """

  # do and end delineate body of our module, and the bodies of the function it contains.
  # Function names are either names or one of the Elixir operators. Must start with a lowercase letter or underscore.
  def word_list do
    words = File.read!("assets/words.txt")
    word_list = String.split(words, "~r/\n/", trim: true)
    IO.write(word_list)
  end
end

### Notes on `mix`
# mix on its own compiles project.
# mix run runs it, and mix run -e <<code>> executes the code in the context of the project.
# iex -S mix starts iex in the context of project; it uses mix to build the application environment and then enters iex
#
# inside iex:
# r ModuleName recompiles the file containing ModuleName
# c "lib/name.ex" compiles the given file

### Misc Notes
# `binary` means a collection of bytes. For most common purposes, `binary` can be mentally substituted for `string`.

# Function id = name/arity(number of params)
