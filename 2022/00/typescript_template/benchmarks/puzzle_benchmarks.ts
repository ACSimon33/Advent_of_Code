// Import benchmarking framework (https://github.com/caderek/benny)
import * as benny from 'benny';

// Import kleur for colored output (https://github.com/lukeed/kleur)
import * as kleur from 'kleur';

// Import puzzle solutions module
import * as typescript_template from '../src/typescript_template';

// Puzzle input
const AoC22_root = process.env['AOC_ROOT'];
const INPUT_FILENAME: string =
  AoC22_root === undefined
    ? './input/puzzle_input.txt'
    : AoC22_root + '/00/typescript_template/input/puzzle_input.txt';

// Output folder
const OUTPUT_DIR: string =
  AoC22_root === undefined
    ? '../../build/benchmarks/00/typescript_template'
    : AoC22_root + '/build/benchmarks/00/typescript_template/';

// Register benchmark suite and export it
module.exports = benny.suite(
  'Day 00 - typescript_template',

  // Benchmark of part 1
  benny.add('Task 1', () => {
    typescript_template.solution_1(INPUT_FILENAME);
  }),

  // Benchmark of part 2
  benny.add('Task 2', () => {
    typescript_template.solution_2(INPUT_FILENAME);
  }),

  // Run becnhmarks
  benny.cycle((result, summary) => {
    if (result.samples) {
      console.log(
        kleur.green(`\n  ${result.name}:\n`) +
          `    ${result.details.mean.toExponential(2)} seconds ` +
          `±${result.margin.toFixed(2)}% (${result.samples} samples)`
      );
    } else {
      console.log(
        kleur.red(`\n  ${result.name}:\n`) + '    No samples recorded!'
      );
    }
  }),

  // Save results as JSON filee
  benny.save({
    file: 'results',
    folder: OUTPUT_DIR,
    details: true,
    format: 'json'
  })
);
