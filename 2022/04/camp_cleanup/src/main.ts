// Day 04: Camp Cleanup

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
    headerContentSections: [{ header: 'Day 04', content: 'Camp Cleanup' }]
  }
);

// ************************************************************************** //

import * as camp_cleanup from './camp_cleanup';

const val_1: number = camp_cleanup.count_contained_sections(args.filename);
console.log('Number of contained sections:', val_1);

const val_2: number = camp_cleanup.count_overlapping_sections(args.filename);
console.log('Number of overlapping sections:', val_2);
