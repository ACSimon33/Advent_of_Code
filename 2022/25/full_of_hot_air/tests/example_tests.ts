// Import puzzle solutions module
import * as full_of_hot_air from '../src/full_of_hot_air.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Full of Hot Air (day 25)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(full_of_hot_air.sum_of_SNAFU_numbers(INPUT_FILENAME)).toBe('2=-1=0');
  });
});
