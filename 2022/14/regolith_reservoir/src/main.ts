// Day 14: Regolith Reservoir

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
    headerContentSections: [{ header: 'Day 14', content: 'Regolith Reservoir' }]
  }
);

// ************************************************************************** //

import * as regolith_reservoir from './regolith_reservoir';

const val_1: number = regolith_reservoir.fill_cave(args.filename, false);
console.log('Sand units without an infinite floor:', val_1);

const val_2: number = regolith_reservoir.fill_cave(args.filename, true);
console.log('Sand units with an infinite floor:', val_2);
