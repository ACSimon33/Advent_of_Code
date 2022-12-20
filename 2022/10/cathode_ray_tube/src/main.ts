// Day 10: Cathode-Ray Tube

// ************************************************************************** //

import { parse } from 'ts-command-line-args';

// Command line arguments
interface AoCArgs {
  filename: string;
  help?: boolean;
}

// Args typed as AoCArgs
export const args = parse<AoCArgs>(
  {
    filename: {
      type: String,
      alias: 'f',
      description: 'Input file (e.g. input/puzzle_input.txt)'
    },
    help: {
      type: Boolean,
      optional: true,
      alias: 'h',
      description: 'Prints this usage guide'
    }
  },
  {
    helpArg: 'help',
    headerContentSections: [{ header: 'Day 10', content: 'Cathode-Ray Tube' }]
  }
);

// ************************************************************************** //

import * as cathode_ray_tube from './cathode_ray_tube.js';

const val_1: number = cathode_ray_tube.signal_strength(args.filename);
console.log('Signal strength:', val_1);

const val_2: string = cathode_ray_tube.display_output(args.filename);
console.log('Display output:');
console.log(val_2);
