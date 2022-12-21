// Import puzzle solutions module
import * as monkey_math from '../src/monkey_math.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Monkey Math (day 21)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(monkey_math.evaluate(INPUT_FILENAME)).toBe(152);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(monkey_math.inverse_evaluate(INPUT_FILENAME)).toBe(301);
  });
});
