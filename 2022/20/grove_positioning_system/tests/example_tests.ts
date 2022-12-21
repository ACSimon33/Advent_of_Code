// Import puzzle solutions module
import * as grove_positioning_system from '../src/grove_positioning_system.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Grove Positioning System (day 20)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(grove_positioning_system.calc_coordinates_sum(INPUT_FILENAME)).toBe(
      3
    );
  });

  // Test of part 2s
  test('Task 2', () => {
    expect(
      grove_positioning_system.calc_coordinates_sum_with_decryption(
        INPUT_FILENAME
      )
    ).toBe(1623178306);
  });
});
