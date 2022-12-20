// Day 03: Rucksack Reorganization

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
      { header: 'Day 03', content: 'Rucksack Reorganization' }
    ]
  }
);

// ************************************************************************** //

import * as rucksack_reorganization from './rucksack_reorganization.js';

const val_1: number = rucksack_reorganization.sum_of_priorities(args.filename);
console.log('Sum of priorities of duplicate items:', val_1);

const val_2: number = rucksack_reorganization.sum_of_badges(args.filename);
console.log('Sum of priorities of badges:', val_2);
