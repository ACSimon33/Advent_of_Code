// Import puzzle solutions module
import * as not_enough_minerals from '../src/not_enough_minerals';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Not Enough Minerals (day 19)', () => {
  // Test of part 1
  test('Task 1', async () => {
    expect(await not_enough_minerals.blueprint_quality(INPUT_FILENAME)).toBe(33);
  });

  // Test of part 2
  test('Task 2', async () => {
    expect(await not_enough_minerals.geodes_product(INPUT_FILENAME)).toBe(62 * 56);
  });
});
