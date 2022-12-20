// Import puzzle solutions module
import * as monkey_in_the_middle from '../src/monkey_in_the_middle.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Monkey in the Middle (day 11)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(monkey_in_the_middle.with_worry_reduction(INPUT_FILENAME)).toBe(
      10605
    );
  });

  // Test of part 2
  test('Task 2', () => {
    expect(monkey_in_the_middle.without_worry_reduction(INPUT_FILENAME)).toBe(
      2713310158
    );
  });
});
