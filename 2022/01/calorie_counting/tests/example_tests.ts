// Import puzzle solutions module
import * as calorie_counting from '../src/calorie_counting';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Calorie Counting (day 01)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(calorie_counting.max_calories(INPUT_FILENAME)).toBe(24000);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(calorie_counting.sum_of_top_three(INPUT_FILENAME)).toBe(45000);
  });
});
