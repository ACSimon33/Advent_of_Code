// Import puzzle solutions module
import * as typescript_template from '../src/typescript_template.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Typescript Template (day 00)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(typescript_template.solution_1(INPUT_FILENAME)).toBe(42);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(typescript_template.solution_2(INPUT_FILENAME)).toBe(43);
  });
});
