// Import benchmarking framework (https://github.com/caderek/benny)
import * as benny from 'benny';

// Import kleur for colored output (https://github.com/lukeed/kleur)
import * as kleur from 'kleur';

// Import puzzle solutions module
import * as not_enough_minerals from '../src/not_enough_minerals';

// Puzzle input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register benchmark suite and export it
module.exports = benny.suite(
  'Day 19 - Not Enough Minerals',

  // Benchmark of part 1
  benny.add('Task 1', () => {
    not_enough_minerals.solution_1(INPUT_FILENAME);
  }),

  // Benchmark of part 2
  // benny.add('Task 2', () => {
  //   not_enough_minerals.solution_2(INPUT_FILENAME);
  // }),

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
    folder: '../../build/benchmarks/19/not_enough_minerals',
    details: true,
    format: 'json'
  })
);
