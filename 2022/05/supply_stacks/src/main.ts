// Day 05: Supply Stacks

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
    headerContentSections: [{ header: 'Day 05', content: 'Supply Stacks' }]
  }
);

// ************************************************************************** //

import * as supply_stacks from './supply_stacks.js';

const val_1: string = supply_stacks.reorder_stacks(args.filename, false);
console.log('Final configuration with CrateMover 9000:', val_1);

const val_2: string = supply_stacks.reorder_stacks(args.filename, true);
console.log('Final configuration with CrateMover 9001:', val_2);
