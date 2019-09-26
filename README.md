# Poker

Elixir library that determines the winning hand in a game of poker

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `poker` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:poker, "~> 0.1.0"}
  ]
end
```

## Example
```elixir
iex> Poker.play(black: "2H 3D 5S 9C KD", white: "2C 3H 4S 8C AH")
    "white wins - high card: Ace"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/poker](https://hexdocs.pm/poker).

