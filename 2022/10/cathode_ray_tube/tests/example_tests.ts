// Import puzzle solutions module
import * as cathode_ray_tube from '../src/cathode_ray_tube.js';

// Example input
const INPUT_FILENAME: string = './input/example_input.txt';

// Register test suite
describe('Cathode-Ray Tube (day 10)', () => {
  // Test of part 1
  test('Task 1', () => {
    expect(cathode_ray_tube.signal_strength(INPUT_FILENAME)).toBe(13140);
  });

  // Test of part 2
  test('Task 2', () => {
    expect(cathode_ray_tube.display_output(INPUT_FILENAME)).toBe(
      '##..##..##..##..##..##..##..##..##..##..\n' +
        '###...###...###...###...###...###...###.\n' +
        '####....####....####....####....####....\n' +
        '#####.....#####.....#####.....#####.....\n' +
        '######......######......######......####\n' +
        '#######.......#######.......#######.....'
    );
  });
});
