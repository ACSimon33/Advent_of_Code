# Advent of Code 2024 - Zig

## Execute puzzles

To execute the solutions with the puzzle input, `cd` into the module folder and run the following `zig` command there:

```
$ cd 00/zig_template
$ zig build run -- -f "input/example_input.txt"
```

You can display help information which might be useful since some puzzles require additional arguments:
```
$ zig build run -- --help
```

## Execute tests

You can either run all tests for the entire workspace via
```
$ zig build test
```
or run the tests for a single day by moving into that day's directory first
```
$ cd 00/zig_template
$ zig build test
```

## Execute benchmarks

You can either run all benchmarks for the entire workspace via
```
$ zig build benchmark -Doptimize=ReleaseFast
```
or run the benchmarks for a single day by moving into that day's directory first
```
$ cd 00/zig_template
$ zig build benchmark -Doptimize=ReleaseFast
```
