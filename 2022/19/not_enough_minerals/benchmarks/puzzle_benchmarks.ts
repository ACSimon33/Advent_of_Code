// Import benchmarking framework (https://github.com/caderek/benny)
import * as benny from 'benny';

// Import kleur for colored output (https://github.com/lukeed/kleur)
import * as kleur from 'kleur';

// Import puzzle solutions module
import * as not_enough_minerals from '../src/not_enough_minerals.js';

// Puzzle input
const INPUT_FILENAME: string = './input/puzzle_input.txt';

// Register benchmark suite and export it
benny.suite(
  'Day 19 - Not Enough Minerals',

  // Benchmark of part 1
  benny.add('Task 1', async () => {
    await not_enough_minerals.blueprint_quality(INPUT_FILENAME);
  }),

  // Benchmark of part 2
  benny.add('Task 2', async () => {
    await not_enough_minerals.geodes_product(INPUT_FILENAME);
  }),

  // Run becnhmarks
  benny.cycle((result, summary) => {
    if (result.samples) {
      console.log(
        `\n  ${result.name}:\n` +
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
