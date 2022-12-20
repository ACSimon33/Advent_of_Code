// Import puzzle solutions module
import * as no_space_left_on_device from '../src/no_space_left_on_device.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('No Space Left On Device (day 07)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(no_space_left_on_device.folders_below_100000(INPUT_FILENAME)).toBe(
      95437
    );
  });

  // Test of part 2
  test('Task 2', () => {
    expect(no_space_left_on_device.find_folder_to_delete(INPUT_FILENAME)).toBe(
      24933642
    );
  });
});
