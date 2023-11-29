# Advent of Code 2023 - Kotlin

## Execute puzzles

To execute the solutions with the puzzle input, `cd` into the package folder and run the following `gradle` command there:

```
$ cd 00/kotlin_template
$ gradle run --args="input/puzzle_input.txt"
```

All programs use `Clikt` to parse command line arguments. So you can display help information which might be useful since some puzzles require additional arguments:
```
$ gradle run --args="--help"
```

## Execute tests

You can either run all tests for the entire workspace via
```
$ gradle test
```
or run the tests for a single day via
```
$ gradle test -p <FOLDER>
```
where `<FOLDER>` is the corresponding day folder, e.g. **00/kotlin_template**.

## Execute benchmarks

You can either run all benchmarks for the entire workspace via
```
$ gradle benchmark
```
or run the benchmarks for a single day via
```
$ gradle benchmark -p <FOLDER>
```
where `<FOLDER>` is the corresponding package name, e.g. **00/kotlin_template**.
