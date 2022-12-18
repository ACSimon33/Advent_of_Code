// Import puzzle solutions module
import * as pyroclastic_flow from '../src/pyroclastic_flow';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Pyroclastic Flow (day 17)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(pyroclastic_flow.cave_height(INPUT_FILENAME, 2022)).toBe(3068);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(pyroclastic_flow.cave_height(INPUT_FILENAME, 1000000000000)).toBe(
      1514285714288
    );
  });
});
