// Import puzzle solutions module
import * as tuning_trouble from '../src/tuning_trouble';

// Example input
const INPUT_FILENAME_1: string = './input/example_input_1.txt';
const INPUT_FILENAME_2: string = './input/example_input_2.txt';
const INPUT_FILENAME_3: string = './input/example_input_3.txt';
const INPUT_FILENAME_4: string = './input/example_input_4.txt';
const INPUT_FILENAME_5: string = './input/example_input_5.txt';

// Register test suite
describe('Tuning Trouble (day 06)', () => {
  // Test of part 1.1
  test('Task 1 - Input 1', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_1, 4)).toBe(7);
  });

  // Test of part 1.2
  test('Task 1 - Input 2', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_2, 4)).toBe(5);
  });

  // Test of part 1.3
  test('Task 1 - Input 3', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_3, 4)).toBe(6);
  });

  // Test of part 1.4
  test('Task 1 - Input 4', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_4, 4)).toBe(10);
  });

  // Test of part 1.5
  test('Task 1 - Input 5', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_5, 4)).toBe(11);
  });

  // Test of part 2.1
  test('Task 2 - Input 1', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_1, 14)).toBe(19);
  });

  // Test of part 2.2
  test('Task 2 - Input 2', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_2, 14)).toBe(23);
  });

  // Test of part 2.3
  test('Task 2 - Input 3', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_3, 14)).toBe(23);
  });

  // Test of part 2.4
  test('Task 2 - Input 4', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_4, 14)).toBe(29);
  });

  // Test of part 2.5
  test('Task 2 - Input 5', () => {
    expect(tuning_trouble.find_start_marker(INPUT_FILENAME_5, 14)).toBe(26);
  });
});
