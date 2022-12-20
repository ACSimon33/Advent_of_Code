// Import puzzle solutions module
import * as boiling_boulders from '../src/boiling_boulders.js';

// Example input
const INPUT_FILENAME_1: string = './input/example_input_1.txt';
const INPUT_FILENAME_2: string = './input/example_input_2.txt';

// Register test suite
describe('Boiling Boulders (day 18)', () => {
  // Test of part 1.1
  test('Task 1 - Input 1', () => {
    expect(boiling_boulders.surface_area(INPUT_FILENAME_1)).toBe(10);
  });

  // Test of part 1.2
  test('Task 1 - Input 2', () => {
    expect(boiling_boulders.surface_area(INPUT_FILENAME_2)).toBe(64);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(boiling_boulders.exterior_surface_area(INPUT_FILENAME_2)).toBe(58);
  });
});
