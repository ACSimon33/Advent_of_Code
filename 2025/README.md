# Advent of Code 2025 - Elixir

## Execute puzzles

To execute the solutions with the puzzle input, `cd` into the module folder and run the following `mix` command there:

```
$ cd apps/day00_elixir_template
$ mix deps.get && mix escript.build
$ mix exec -f .\input\example_input.txt"
```

You can display help information which might be useful since some puzzles require additional arguments:
```
$ mix exec --help
```

## Execute tests

You can either run all tests for the entire workspace via
```
$ mix test
```
or run the tests for a single day by moving into that day's directory first
```
$ cd apps/day00_elixir_template
$ mix test
```

## Execute benchmarks

You can either run all benchmarks for the entire workspace via
```
$ mix bench
```
or run the benchmarks for a single day by moving into that day's directory first
```
$ cd apps/day00_elixir_template
$ mix bench
```
