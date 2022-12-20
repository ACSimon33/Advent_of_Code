// Import benchmarking framework (https://github.com/caderek/benny)
import * as benny from 'benny';

// Import kleur for colored output (https://github.com/lukeed/kleur)
import { red, green } from 'kleur/colors';

// Import puzzle solutions module
import * as boiling_boulders from '../src/boiling_boulders.js';

// Puzzle input
const INPUT_FILENAME: string = './input/puzzle_input.txt';

// Register benchmark suite and export it
export const suite = benny.suite(
  'Day 18 - Boiling Boulders',

  // Benchmark of part 1
  benny.add('Task 1', () => {
    boiling_boulders.surface_area(INPUT_FILENAME);
  }),

  // Benchmark of part 2
  benny.add('Task 2', () => {
    boiling_boulders.exterior_surface_area(INPUT_FILENAME);
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
      console.log(red(`\n  ${result.name}:\n`) + '    No samples recorded!');
    }
  }),

  // Save results as JSON filee
  benny.save({
    file: 'results',
    folder: '../../build/benchmarks/18/boiling_boulders',
    details: true,
    format: 'json'
  })
);
