// Day 19: Not Enough Minerals

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
      { header: 'Day 19', content: 'Not Enough Minerals' }
    ]
  }
);

// ************************************************************************** //

import * as not_enough_minerals from './not_enough_minerals';

const val_1: number = await not_enough_minerals.solution_1(args.filename);
console.log('Blueprint quality sum:', val_1);

const val_2: number = await not_enough_minerals.solution_2(args.filename);
console.log('Geode product:', val_2);
