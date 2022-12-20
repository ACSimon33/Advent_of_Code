// Import benchmarking framework (https://github.com/caderek/benny)
import * as benny from 'benny';

// Import kleur for colored output (https://github.com/lukeed/kleur)
import { red, green } from 'kleur/colors';

// Import puzzle solutions module
import * as beacon_exclusion_zone from '../src/beacon_exclusion_zone.js';

// Puzzle input
const INPUT_FILENAME: string = './input/puzzle_input.txt';

// Register benchmark suite and export it
export const suite = benny.suite(
  'Day 15 - Beacon Exclusion Zone',

  // Benchmark of part 1
  benny.add('Task 1', () => {
    beacon_exclusion_zone.invalid_positions(INPUT_FILENAME, 2000000);
  }),

  // Benchmark of part 2
  benny.add('Task 2', () => {
    beacon_exclusion_zone.tuning_frequency(INPUT_FILENAME, 4000000);
  }),

  // Run becnhmarks
  benny.cycle((result) => {
    if (result.samples) {
      console.log(
        green(`\n  ${result.name}:\n`) +
          `    ${result.details.mean.toExponential(2)} seconds ` +
          `±${result.margin.toFixed(2)}% (${result.samples} samples)`
      );
    } else {
      console.log(
        red(`\n  ${result.name}:\n`) + '    No samples recorded!'
      );
    }
  }),

  // Save results as JSON filee
  benny.save({
    file: 'results',
    folder: '../../build/benchmarks/15/beacon_exclusion_zone',
    details: true,
    format: 'json'
  })
);
