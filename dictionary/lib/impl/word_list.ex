# Module names must be an Elixir Atom. Conventionally with CapitalizedWords.
defmodule Dictionary.Impl.WordList do
  # @ defines a module attribute, which is created at compile time.
  # The initial value of the attribute is determined by the code used to define it.

  @type t :: list(String)

  def word_list do
    "assets/words.txt"
    # |> is an operator that takes the operand and puts it as the first argument
    |> File.read!()
    |> String.split(~r/\n/, trim: true)
  end

  # do and end delineate body of our module, and the bodies of the function it contains.
  # Function names are either names or one of the Elixir operators. Must start with a lowercase letter or underscore.
  @spec random_word(t) :: String.t()
  def random_word(word_list) do
    word_list |> Enum.random()
  end
end

defmodule Temp do
  def swap({a, b}) do
    {b, a}
  end

  def same(a, a) do
    true
  end

  def same(_, _) do
    false
  end
end

defmodule Lists do
  def len([]), do: 0
  def len([_h | t]), do: 1 + len(t)

  def sum([]), do: 0
  def sum([h | t]), do: h + sum(t)

  def square([]), do: []
  def square([h | t]), do: [h * h | square(t)]

  def mult([], _x), do: []
  def mult([h | t], x), do: [h * x | mult(t, x)]

  # This is like what the module `Enum.map` does.
  def map([], _func), do: []
  def map([h | t], func), do: [func.(h) | map(t, func)]

  def sum_pair([]), do: []
  def sum_pair([t]), do: [t | []]
  def sum_pair([h1, h2 | t]), do: [h1 + h2 | sum_pair(t)]

  def even_length?([]), do: true
  def even_length?([_t]), do: false
  def even_length?([_h1, _h2 | t]), do: even_length?(t)
end
