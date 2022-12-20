// Import puzzle solutions module
import * as treetop_tree_house from '../src/treetop_tree_house.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Treetop Tree House (day 08)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(treetop_tree_house.number_of_visible_trees(INPUT_FILENAME)).toBe(21);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(treetop_tree_house.max_scenic_score(INPUT_FILENAME)).toBe(8);
  });
});
