// Import puzzle solutions module
import * as monkey_map from '../src/monkey_map.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Monkey Map (day 22)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(monkey_map.solution_1(INPUT_FILENAME)).toBe(42);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(monkey_map.solution_2(INPUT_FILENAME)).toBe(43);
  });
});
