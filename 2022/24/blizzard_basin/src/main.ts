// Day 24: Blizzard Basin

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
    headerContentSections: [{ header: 'Day 24', content: 'Blizzard Basin' }]
  }
);

// ************************************************************************** //

import * as blizzard_basin from './blizzard_basin.js';

const val_1: number = blizzard_basin.traverse(args.filename);
console.log('Time to traverse the basin:', val_1);

const val_2: number = blizzard_basin.traverse_three_times(args.filename);
console.log('Time to traversethe basin three times:', val_2);
