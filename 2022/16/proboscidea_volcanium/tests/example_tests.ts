// Import puzzle solutions module
import * as proboscidea_volcanium from '../src/proboscidea_volcanium';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Proboscidea Volcanium (day 16)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(proboscidea_volcanium.max_pressure_release(INPUT_FILENAME, 0)).toBe(
      1651
    );
  });

  // Test of part 2
  test('Task 2', () => {
    expect(proboscidea_volcanium.max_pressure_release(INPUT_FILENAME, 1)).toBe(
      1707
    );
  });
});
