# Elixir Notes

## General Info

### Notes on `mix`

mix on its own compiles project.

`mix run` runs it, and mix `run -e <<code>>` executes the code in the context of the project.

iex -S mix starts iex in the context of project; it uses mix to build the application environment and then enters iex

inside iex:
r ModuleName recompiles the file containing ModuleName
c "lib/name.ex" compiles the given file

### Misc Notes

`binary` means a collection of bytes. For most common purposes, `binary` can be mentally substituted for `string`.

Function id = name/arity(number of params)

In a functional language, every function returns a value.
In elixir, the return value of a function is the last statement that is executed in that function

OO has methods, FP has functions
In OO, objects change their state by invoking instance methods. This means that state is coupled to behavior.

In FP, state is decoupled from behavior. State is always immutable.
Functions transform state into new state. They never change the state that's given them.
Idead functions are pure: given a particular input, they will always produce the same output.
This increases composability and reusability of functions.

The goal with FP is to think about our programs as one big function, transforming its inputs to outputs.
Then, we break it down into progressively smaller functions, until we end up with a bunch of small functions; each function doing one thing.

The main tools are functional composition and pattern matching.
Functional Composition:
Chaining functions so that the output of one becomes the input of the next.

Pattern Matching:
Allows writing different versions of the same function.
The version that is called depends on the value that is passed in.

## Integers and Floats

ints can be arbitrarily big (within the limits of available memory).\
They can be written with underscores between them, usually to denote commas.\
`123_456_789`

`0x`, `0o`, `0b` prefixes indicate literals using hex, octal, binary notation.

`?` gives the codepoint of the UTF character that comes after it. For example, `?A` = 65.

Integer division always returns a fload. The `div` function returns a truncated integer.\
`8/3 2.666666666665`
`div(8/3) = 2`

There are also `trunc` and `round` functions.

Elixir supports exponents on floats with `e`.
