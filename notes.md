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

---

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

---

## Atoms

Atoms are constants that are used to name things. Kind of like strings, but with different representation.

To create an atom, prefix a name with `:`\
`:cat`, `:cat_dog`, `:>=`\
To create atoms that contain characters not allowed in regular strings use quotes.\
`:"cat-dog"`, `:"cat dog"`, `:"!@#$%^&*"`

This format allows embedding the result of evaluating code in atom names:

```elixir
a = 99
:"next-number: #{a+1}" # "next-number: 100"
```

\
Another way to create an atom is to use a name that starts with an uppercase letter. Note that this is what module names are. When writing `defmodule Dictionary`, Elixir converts `Dictionary` into an atom. To avoid name clashes with the Erlang std library modules, Elixir adds the prefix `Elixer` to atoms derived from capitalized letters.

```elixir
is_atom(Dictionary) # true
Dictionary == :"Elixir.Dictionary" # true
```

---

## Booleans

`true` and `false`.

Elixir treats the constant `nil` and `false` as being a falsy; all other values are truthy.

There are two sets of logical operators: `(&&, ||, !)` and `(and, or, not)`. The latter only accept `true` or `false` on their left hand side.

`&&` and `and` return their right hand value if the left hand is truthy, `||` and `or` return the right hand value if the left is falsy.

To use bitwise boolean operators, use the `Bitwise` library.

---

## Ranges

```elixir
iex> a = 5..10
5..10
iex> b = 8..3
8..3
iex> 4 in a
false
iex> 4 in b
true
iex> for i <- b, do: i*3
[24, 21, 18, 15, 12, 9]
```

---

## Sigils

More general string-like constants.

In `String.split(str, ~r/\n/)`, `~r...` is an example of an Elixir sigil-a generic way of writing string-like constants. In other words, a sigil is a notation for creating values from strings. The string was `\n` and the value created was the corresponding regex.

All sigils start with `~`, then followed by a single letter that determines type of value to be generated. Next is the string, between delimiters, and then lastly there may be some optional flags.

Possible delimiters:

```elixir
~r/.../     ~r"..."     -r'...'     ~r|...|
~r<...>     ~r[...]     ~r(...)     ~r{...}

~r"""
 :
 :
"""
```

Optional flag interpretations depend on the sigil. In `~r/foo/i`, it makes the pattern match case insensitive.

Some Sigils that come as a part of Elixir (there are also `~D//`,`~N//`, and `~T//`, that generate dates and times):

```elixir
~c// ~C// list of character codes
~r// ~R// regular expression
~s// ~S// string
~w// ~W// list of words
```

Examples:

```elixir
iex> ~c/cat\0/
[99, 97, 116, 0]
iex> ~r/cat/i
~r/cat/i
iex> ~s/dog/
"dog"
iex> ~w/now is the time/
["now", "is", "the", "time"]
```

The lowercase sigils expand escape sequences and interpolate embedded expressions:

```elixir
iex> name = "Betty"
"Betty"
iex> ~s/Hello #{name}\n/
"Hello Betty\n"
iex> ~c/#{name}\0/
[66, 101, 116, 116, 121, 0]
```

The uppercase do no expansion:

```elixir
iex> ~S/Hello #{name}\n/
"Hello \#{name}\\n"
```

## Strings

A sequence of unicode codepoints.

`"hello"` is equivalent to `~s{hello}`. `'hello'` is the same as `~c{hello}` and it generates a list of char codepoints, not a string.

Backslash expansion and expression interpolation is enabled in double quoted strings:

```elixir
"Name:\t#{name}\nAge:\t#{ trunc(age) }"
```

To turn off the substitutations, use `~S` sigil:

```elixir
~S"Name:\t#{name}\nAge:\t#{ trunc(age) }"
```

The `<>` operator concatenates strings; functions in `String` module manipulate them.

## Regular Expression Literals

`~r/name:\s*(\w+)/`

`Regex` module contains most functions that work with regex. Additionally, the `=~` operator can perform a regex match.

```elixir
iex> str = "once upon a time"
"once upon a time"
iex> str =~ ~r/u..n/
true
iex> str =~ ~r/u..m/
false
```

`~=` also accepts a string as right hand arg; returns `true` if left string contains the right.

## Tuples

A fixed length collection of values. Can contain values of different types.

```elixir
{ :ok, "wilma" }
{ :reply, destination, "rain with chance of hail" }
{ 1, 2, 3+4 }
```

Typically used to pass flagged values to and from functions. For example, upon success, `File.read` returns the tuple:
`{:ok, contents}`

The first element is the atom `:ok`.

## Lists

They are not arrays! An array is a contiguous area of memory containing fixed size cells. To get to the nth element of an array, you can perform address arithmetic.

Lists are a sequence of zero or more elements, with one linked to the next. To get to the nth element, you have to start from the first and follow the links.

This means that it is easy to add a new element at the head of a list, or remove that element.

Even though the lists are built as a series of head/tail pairs, IEx displays it as a simple list of values.

You can write lists as the comma seperated values, but remember that non-empty lists always have a head, which is a value, and a tail, which is a list.

```elixir
iex> empty = []
[]

iex> list_3 = [ 3 | empty ]
[3]

iex> list_2_3 = [ 2 | list_3 ]
[2, 3]

iex> list_1_2_3 = [ 1 | list_2_3 ]
[1, 2, 3]
```

Improper lists do not have an do not have an empty tail and should not be used.

## Maps

```elixir
iex> countries = %{
...> "BFA" => "Burkina Faso",
...> "BDI" => "Burundi",
...> "KHM" => "Cambodia",
...> "CMR" => "Cameroon",
...> "CAN" => "Canada",
...> }
%{"BDI" => "Burundi", "BFA" => "Burkina Faso",
  "CAN" => "Canada",  "CMR" => "Cameroon",
  "KHM" => "Cambodia"}

iex> countries["BFA"]
"Burkina Faso"

iex> countries["XXX"]
nil

iex> countries[123]
nil
```

Maps are unordered collection of key/value pairs. Both keys and values can be any Elixir type, and those types can be mixed within a map.

```elixir
%{ key1 => value1, key2 => value2, . . . }
```

`Map` and `Enum` modules are used to work with maps. `map[key]` shortcut returns the value corresponding to `key` or `nil`

maps are often used as lookup tables, where the keys are all atoms. For those cases, there is a shortcut syntax to create a map:

```elixir
iex> multipliers = %{ once: 1, twice: 2, thrice: 3 }
%{once: 1, thrice: 3, twice: 2}

iex> 5 * multipliers[:twice]
10

iex> 5 * multipliers.twice
10
```

In a map constant, `once: 1` is the same as writing `:once => 1`. If the map's keys are atoms, you can access the values using the `map.key` notation.

What is the difference between `map.key` and `map[:key]`? Here is an example showing you:

When you use the [] notation, then a map either returns the value or nil. When you use the dot notation, Elixir raises an error for unknown keys.

```elixir
iex(1)> map = %{ one: "first", two: "second" }
%{one: "first", two: "second"}
iex(2)> map[:one]
"first"
iex(3)> map.one
"first"
iex(4)> map[:three]
nil
iex(5)> map.three
** (KeyError) key :three not found in: %{one: "first", two: "second"}
```

## Patern matching

Match arbirtrary structured data against a pattern, extract elements of that data along the way, and choose what code to run based on the patterns that match.

`a = 1` does not assign `a` to `1`, it binds `a` to `1`.
This means that `1 = a` will not give an error.

When calling a function, the arfuments passed are not assigned to the parameters. Each argument is pattern matched to its parameter.

For example, this func takes a two element tuple. Calling `func({1,2})` binds 1 to a and 2 to b:

```elixir
def func({ a, b }) do
  IO.puts "a = #{a}, b = #{b}"
end
```

We could also have the argument matched to the parameter so that we can access the tuple itself and both components of the tuple. Here, two pattern matches take place, and three variables are bound.

```elixir
def func(t = { a, b }) do
  IO.puts "a = #{a}, b = #{b}, is_tuple{t}"
end
# t = {a,b} = {1,2}
```

This function is invoked only if it is passed a two element tuple where the first element is the atom `:ok`.

```elixir
def read_file({ :ok, file }) do
  ...
end
```

Example of function overloading:

```elixir
def read_file({ :ok, file }) do
  file
  |> IO.read(:line)
end

def read_file({ :error, reason }) do
  Logger.error("File error: #{reason}")
  []
end

"my_file.txt"
|> File.open
|> read_file
```

To Elixir, a list `[1, 2, 3]` looks like:

```elixir
[ 1 | [ 2 | [ 3 | [] ] ] ]
```

When matching lists, you can have multiple head elements in the match:

```elixir
[ a, b | tail ]       # matches a list of two or more elements,
                      # putting the first into a, the second in b,
                      # and the rest as a list in tail

[ a, a | tail ]       # matches a list where the first two elements
                      # are the same

[ a | [ a | tail ] ]  # same as the previous example
```

## Structures

Declared with `defstruct()`

Like maps, but the list of keys are predefined and cannot be changed at runtime.

Structures are always associated with a module, and the structure will always have the name of the module. Structures are meant to hold the data that is processed by that module's functions.

## Pattern matching in functions

```elixir
def make_move(game = %{ game_state: state }, _guess)
```

This will match any call where the first parameter is a map containing a key game_state. The corresponding value will be bound to the parameter state, and the overall map will be bound to game.

A when clause (also called a guard clause) can further restrict when a particular variant of a function can be called. The when is executed after the parameters are bound, so the values of parameters can be used.

## About Loops

Every time a pattern match occurs in Elixir, a new variable is created. This means that if a variable is defined outside a comprehension body, then reassigned inside, the value would not be updated.

This function is not tail recursive because the last operation executed before the recursive call would be `+`, not the recursive call itself.

```elixir
def sum(0), do: 0
def sum(n), do: n + sum(n-1)
```

To allow tail optimization, it would have to be the following. Now the last operation executed is the recursive call itself:

```elixir
def sum(n), do: sum(n, 0)
defp sum(0, acc), do: acc
defp sum(n, acc), do: sum(n - 1, acc + n)
```

## Concurrency

The elixir model of concurrency is built on sending messages between processes.

A `process` is internal to the Elixir runtime system, it is not an OS process.
Elixir process are much more efficient.

`spawn` runs a function in a seperate process. It takes either an anonymous function or MFA (Module, Function, Arguments).
The module part is its name, the function is the function name as an atom,
and the arguments are represented as a list.

`sleep` is rarely used in actual code. If you are using it, try to think about a better way.

## Runtime vs. Implementation Divide

Applications can be structured such that the runtime and implementation code is seperated.

The environment in which the code runs include the following. It kicks off the processes, monitors them, etc. Basically the server itself. In our case, it is anything in the `runtime/` directory:

- process structure
- configuration
- error handling
- scaling

The code that implements the business logic include. In our case, it is anything in the `impl/` directory:

- problem specific code
- algorithms
- data strcutures
- Anything that is unit tested

In elixir, an `application` is something that starts itself automatically and manages its own lifecycle. This means that the application can choose to restart itself in the event that it crashes.

## Project to Application

An elixir project can be a plain library, which is just the code, and has no independent existence.

As soon as that library can run its own process and has its own state, it becomes an application.
This includes implementing the following:

- write a module to start processes
- tell runtime where to find this module

A typical application is usually a hybrid; having code that runs in the context of its own processes, and also code that is called directly from other applications, and code which runs in their processes. The latter is the interface from the application to the outside world.

## How to Decide between putting code in the processes runtime repo vs. the application logic impl directories?

First, think about ownership of state.

If the code needs to persist some state, then it will need to be in a process.
State can only be accessed by code that is executing, and so that code will need a process on which to run.

If the code is just mutating data, then it is likely to be a pure function.
This function does not maintain state; it receives it as a parameter, then forgets when it exits.

Second, functions are easier than processes.
The more stuff you can put into the `impl` tree, the easier you'll make things for yourself and for the people who will have to work with the code.
The process side will always be "in control", but delegate to the functional side as soon as possible.

## Supervisors

A supervisor monitors one or more processes.

A supervisor is just another process, so supervisors can monitor other supervisors.

Supervisors sit outside the regular process structure.

Supervision is a separate concern from application functionality.
Therefore, tests should try to be written separately from the application logic.
In a way, supervision tests are like integration tests.

## Agents

A specific kind of server that is designed to hold state, and execute functions on that state.

For most logic, and many servers, we need more than that. That is what GenServers are for.

## GenServer

Gen(eric)Server

A server is an independent process. This is code that will wrap any server in the elixir world.
It is an abstraction that allows us to write code that runs in a server without worrying
about details such as lifecycle management, timeouts, resource allocation, failure monitoring, etc.

GenServers have two APIs, the external API that has code which runs in the client process, and an internal callback which runs in the server process.

They communicate via messages but live in different environment.

The calling process stops, monitors, and invokes (calls) the server process.

The server code is called using callbacks. For example, there will be callbacks saying that a new server is going to be initialized, somebody want to do a function on you, etc.

Calling process:

```elixir
{:ok, pid} = GenServer.start_link(GameServer, args)

return_value = GenServer.call(pid, {:make_move, "a"})
```

Server process:

```elixir
defmodule GameServer do
  use GenServer

  # GenServer calls this function while starting server
  def init(args) do
    state = create_state(args)
    # `state` is passed into all subsequent callbacks
    {:ok, state}
  end

  # one function handles all calls made from GenServer,
  # pattern matching the other possibilities.
  def handle_call({:make_move, guess}, _from, state) do
    # makes move, and updates state.
    {:reply, return_value, new_state}
  end

end
```

## Nodes

Every instance of an elixir VM creates a `node`. Typing `iex` or `mix` at commnad line creates a node. In that node, `applications` are run.

Instances of the same application in seperate nodes are completely independent.

By default, each Node is isolated from all other nodes. The only way for two nodes to connect is by both having a name.

There are two kinds of Node names. Short name and long name.

Short name = fred@quarry
Long name = wilma@quarry.bedrock.com (or the ip address)

Typicaly will use short name if all nodes are on same computer.
Long names otherwise.

Cannot mix the two. All node names must either be short or long.

To start a node:\
mix --sname fred\
mix --name wilma@quarry.bedrock.com

Nodes try to connect the first time one references another.

To do that manually:

`Node.connect(:fred@myhost)`

Node connections are transitive: If two nodes are connected, and a third node connects to either of them, all three nodes become interconnected. However, this can be arranged that it does not happen. Useful for large networks.

Elixir is largely network transparent: Something you can do on one node can mostly be done on a remote node as well:\

- Process creation
- Linking
- Monitoring
- Message passing (sometimes another token will need to be added for this)

## Process Identifier (pid)

PID: #PID<Node.processId>

Local PID: `#PID<0.90.0>`
Registered name: `:chatbot`
Name + node: `{:chatbot, :n1@farm.com}`
Remote PID: `#PID<12786.90.0>`

If a node sends a PID to another node, then that PID is automatically translated on the way out. It will have the node ID placed in the first digit of the PID. Also, any messages sent to that newly connected Node that was intended for the original node will be rerouted to the original Node.

This means that once two nodes are connected, they will automatically map PIDs sent between them so that a reply can always go back to the correct node.

## Naming a PID

```elixir
pid = spawn . . .
Process.register(pid, :my_process)

send(pid, :hello)
# is the same as...
send(:my_process, :hello)
```

You can send to a process on another node by using a tuple cointaining the process name and node name in place of the pid:

```elixir
send( { :my_process, :node1@quarry }, :hello )
```

Elixir does not have a reply function for their messages, they are strictly one way.
If you want something back, you have to tell the remote process where to send it to.
