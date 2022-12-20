// Import puzzle solutions module
import * as rucksack_reorganization from '../src/rucksack_reorganization.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Rucksack Reorganization (day 03)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(rucksack_reorganization.sum_of_priorities(INPUT_FILENAME)).toBe(157);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(rucksack_reorganization.sum_of_badges(INPUT_FILENAME)).toBe(70);
  });
});
