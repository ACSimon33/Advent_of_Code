// Import benchmarking framework (https://github.com/caderek/benny)
import * as benny from 'benny';

// Import kleur for colored output (https://github.com/lukeed/kleur)
import { red, green } from 'kleur/colors';

// Import puzzle solutions module
import * as proboscidea_volcanium from '../src/proboscidea_volcanium.js';

// Puzzle input
const INPUT_FILENAME: string = './input/puzzle_input.txt';

// Register benchmark suite and export it
export const suite = benny.suite(
  'Day 16 - Proboscidea Volcanium',

  // Benchmark of part 1
  benny.add('Task 1', () => {
    proboscidea_volcanium.max_pressure_release(INPUT_FILENAME, 30, 0);
  }),

  // Benchmark of part 2 (takes too long)
  benny.add('Task 2', () => {
    proboscidea_volcanium.max_pressure_release(INPUT_FILENAME, 20, 1);
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
    folder: '../../build/benchmarks/16/proboscidea_volcanium',
    details: true,
    format: 'json'
  })
);
