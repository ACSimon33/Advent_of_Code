// Import puzzle solutions module
import * as distress_signal from '../src/distress_signal.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Distress Signal (day 13)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(distress_signal.correct_order(INPUT_FILENAME)).toBe(13);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(distress_signal.decoder_key(INPUT_FILENAME)).toBe(140);
  });
});
