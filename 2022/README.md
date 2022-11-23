# Advent of Code 2022 - Typescript

## Install dependencies
```
$ npm install
```

## Execute puzzles

To execute the solutions with the puzzle input, `cd` into the workspace folder and run the following commands there:

```
$ cd 00/typescript_template
$ npm run tsc
$ npm run exec -- -f input/puzzle_input.txt
```

All programs use `ts-command-line-args` to parse command-line arguments. So you can display help information which might be useful since some puzzles require additional arguments:
```
$ npm run exec -- --help
```

## Execute tests

You can either run all tests for the entire workspace via
```
$ npm test -ws
```
or run the tests for a single day via
```
$ npm test -w <WORKSPACE>
```
where `<WORKSPACE>` is the corresponding workspace path, e.g. **00/typescript_template**. You can also `cd` into the workspace folder and run the tests from there.

## Execute benchmarks

You can either run all benchmarks for the entire workspace via
```
$ npm run benchmark -ws
```
or run the benchmarks for a single day via
```
$ npm run benchmark -w <WORKSPACE>
```
where `<WORKSPACE>` is the corresponding workspace path, e.g. **00/typescript_template**. You can also `cd` into the workspace folder and run the benchmarks from there.
