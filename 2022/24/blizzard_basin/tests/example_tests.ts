// Import puzzle solutions module
import * as blizzard_basin from '../src/blizzard_basin.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Blizzard Basin (day 24)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(blizzard_basin.traverse(INPUT_FILENAME)).toBe(18);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(blizzard_basin.traverse_three_times(INPUT_FILENAME)).toBe(54);
  });
});
