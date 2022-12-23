// Import puzzle solutions module
import * as unstable_diffusion from '../src/unstable_diffusion.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Unstable Diffusion (day 23)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(unstable_diffusion.empty_tiles(INPUT_FILENAME)).toBe(110);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(unstable_diffusion.steady_state(INPUT_FILENAME)).toBe(20);
  });
});
