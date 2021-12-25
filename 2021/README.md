# Advent of Code 2021

[⭢ *Benchmarks* ⭠](https://acsimon33.github.io/Advent_of_Code/2021/report/index.html)

## Execute tests

You can either run all tests for the entire workspace via
```
$ cargo test
```
or run the tests for a single day via
```
$ cargo test -p <PACKAGE>
```
where `<PACKAGE>` is the corresponding package name, e.g. **dive**, **binary_diagnostic**, **giant_squid**, etc.

## Execute puzzles

In order to execute the solutions with the puzzle input, `cd` into the package folder and run following `cargo` command there:

```
$ cd 04/giant_squid
$ cargo run --release -- -f input/puzzle_input.txt
```

All programs use `clap` to parse command line arguments. So you can display help information which might be useful since some puzzle require additional arguments:
```
$ cargo run -- --help
```

## Execute benchmarks

You can either run all benchmarks for the entire workspace via
```
$ cargo bench
```
or run the benchmarks for a single day via
```
$ cargo bench -p <PACKAGE>
```
where `<PACKAGE>` is the corresponding package name, e.g. **dive**, **binary_diagnostic**, **giant_squid**, etc.
