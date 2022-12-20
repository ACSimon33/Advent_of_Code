// Import puzzle solutions module
import * as rope_bridge from '../src/rope_bridge.js';

// Example input
const INPUT_FILENAME_1: string = './input/example_input_1.txt';
const INPUT_FILENAME_2: string = './input/example_input_2.txt';

// Register test suite
describe('Rope Bridge (day 09)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(rope_bridge.tail_positions(INPUT_FILENAME_1, 2)).toBe(13);
  });

  // Test of part 2.1
  test('Task 2 - Input 1', () => {
    expect(rope_bridge.tail_positions(INPUT_FILENAME_1, 10)).toBe(1);
  });

  // Test of part 2.2
  test('Task 2 - Input 2', () => {
    expect(rope_bridge.tail_positions(INPUT_FILENAME_2, 10)).toBe(36);
  });
});
