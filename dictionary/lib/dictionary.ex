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

  # @ defines a module attribute, which is created at compile time.
  # The initial value of the attribute is determined by the code used to define it.
  @word_list "assets/words.txt"
             # |> is an operator that takes the operand and puts it as the first argument
             |> File.read!()
             |> String.split(~r/\n/, trim: true)

  # do and end delineate body of our module, and the bodies of the function it contains.
  # Function names are either names or one of the Elixir operators. Must start with a lowercase letter or underscore.
  def random_word do
    @word_list
    |> Enum.random()
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

# In a functional language, every function returns a value.
# In elixir, the return value of a function is the last statement that is executed in that function

# OO has methods, FP has functions
# In OO, objects change their state by invoking instance methods. This means that state is coupled to behavior.
#
# In FP, state is decoupled from behavior. State is always immutable.
# Functions transform state into new state. They never change the state that's given them.
# Idead functions are pure: given a particular input, they will always produce the same output.
# This increases composability and reusability of functions.
#
# The goal with FP is to think about our programs as one big function, transforming its inputs to outputs.
# Then, we break it down into progressively smaller functions, until we end up with a bunch of small functions; each function doing one thing.
#
# The main tools are functional composition and pattern matching.
# Functional Composition:
# Chaining functions so that the output of one becomes the input of the next.
#
# Pattern Matching:
# Allows writing different versions of the same function.
# The version that is called depends on the value that is passed in.
