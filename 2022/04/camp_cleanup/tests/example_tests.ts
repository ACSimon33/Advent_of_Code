// Import puzzle solutions module
import * as camp_cleanup from '../src/camp_cleanup';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Camp Cleanup (day 04)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(camp_cleanup.count_contained_sections(INPUT_FILENAME)).toBe(2);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(camp_cleanup.count_overlapping_sections(INPUT_FILENAME)).toBe(4);
  });
});
