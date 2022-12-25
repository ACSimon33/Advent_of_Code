// Day 25: Full of Hot Air

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
    headerContentSections: [{ header: 'Day 25', content: 'Full of Hot Air' }]
  }
);

// ************************************************************************** //

import * as full_of_hot_air from './full_of_hot_air.js';

const val_1: string = full_of_hot_air.sum_of_SNAFU_numbers(args.filename);
console.log('Sum of SNAFU numbers:', val_1);
