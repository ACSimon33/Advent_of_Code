// Import puzzle solutions module
import * as beacon_exclusion_zone from '../src/beacon_exclusion_zone';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Beacon Exclusion Zone (day 15)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(beacon_exclusion_zone.invalid_positions(INPUT_FILENAME, 10)).toBe(
      26
    );
  });

  // Test of part 2
  test('Task 2', () => {
    expect(beacon_exclusion_zone.tuning_frequency(INPUT_FILENAME, 20)).toBe(
      56000011
    );
  });
});
