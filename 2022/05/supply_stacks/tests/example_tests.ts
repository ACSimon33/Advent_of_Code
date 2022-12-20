// Import puzzle solutions module
import * as supply_stacks from '../src/supply_stacks.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Supply Stacks (day 05)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(supply_stacks.reorder_stacks(INPUT_FILENAME, false)).toBe('CMZ');
  });

  // Test of part 2
  test('Task 2', () => {
    expect(supply_stacks.reorder_stacks(INPUT_FILENAME, true)).toBe('MCD');
  });
});
