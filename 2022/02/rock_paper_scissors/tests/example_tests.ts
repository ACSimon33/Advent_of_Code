// Import puzzle solutions module
import * as rock_paper_scissors from '../src/rock_paper_scissors';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Rock Paper Scissors (day 02)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(rock_paper_scissors.guess_instructioons(INPUT_FILENAME)).toBe(15);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(rock_paper_scissors.follow_instructioons(INPUT_FILENAME)).toBe(12);
  });
});
