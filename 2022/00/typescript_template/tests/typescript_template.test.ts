// Example input
const INPUT_FILENAME: string = "input/example_input.txt";

// Import puzzle solutions module
import * as typescript_template from "../src/typescript_template";

// Register test suite
describe('Testing typescript template project (day 0)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(typescript_template.solution_1(INPUT_FILENAME)).toBe(3);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(typescript_template.solution_2(INPUT_FILENAME)).toBe(6);
  });
});
