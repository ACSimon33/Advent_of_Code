// Day 20: Grove Positioning System

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
    headerContentSections: [
      { header: 'Day 20', content: 'Grove Positioning System' }
    ]
  }
);

// ************************************************************************** //

import * as grove_positioning_system from './grove_positioning_system.js';

const val_1: number = grove_positioning_system.calc_coordinates_sum(
  args.filename
);
console.log('Sum of coordinates:', val_1);

const val_2: number =
  grove_positioning_system.calc_coordinates_sum_with_decryption(args.filename);
console.log('Sum of coordinates after decrypting 10 times:', val_2);
