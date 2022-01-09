defmodule Dictionary.Runtime.Server do
  @type t :: pid()
  alias Dictionary.Impl.WordList

  # This adds the `child_spec` function which returns a data structure
  # containing the child's paramters.
  use Agent

  # a module attribute with the value of the full module name from defmodule
  @me __MODULE__

  def start_link(_) do
    # Starts the agent with a pid, then registers under the name of atom `:wilma`
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  @spec random_word :: any
  def random_word() do
    Agent.get(@me, &WordList.random_word/1)
  end
end
