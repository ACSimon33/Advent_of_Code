// Import puzzle solutions module
import * as regolith_reservoir from '../src/regolith_reservoir';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Regolith Reservoir (day 14)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(regolith_reservoir.fill_cave(INPUT_FILENAME, false)).toBe(24);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(regolith_reservoir.fill_cave(INPUT_FILENAME, true)).toBe(93);
  });
});
