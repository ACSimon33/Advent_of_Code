// Import benchmarking framework (https://github.com/caderek/benny)
import * as benny from 'benny';

// Import kleur for colored output (https://github.com/lukeed/kleur)
import * as kleur from 'kleur';

// Import puzzle solutions module
import * as tuning_trouble from '../src/tuning_trouble';

// Puzzle input
const INPUT_FILENAME: string = './input/puzzle_input.txt';

// Register benchmark suite and export it
module.exports = benny.suite(
  'Day 06 - Tuning Trouble',

  // Benchmark of part 1
  benny.add('Task 1', () => {
    tuning_trouble.find_start_marker(INPUT_FILENAME, 4);
  }),

  // Benchmark of part 2
  benny.add('Task 2', () => {
    tuning_trouble.find_start_marker(INPUT_FILENAME, 14);
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
    folder: '../../build/benchmarks/06/tuning_trouble',
    details: true,
    format: 'json'
  })
);
