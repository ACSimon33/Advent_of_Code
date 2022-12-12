// Import puzzle solutions module
import * as hill_climbing_algorithm from '../src/hill_climbing_algorithm';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Hill Climbing Algorithm (day 12)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(hill_climbing_algorithm.shortest_path(INPUT_FILENAME)).toBe(31);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(hill_climbing_algorithm.shortest_path_overall(INPUT_FILENAME)).toBe(
      29
    );
  });
});
