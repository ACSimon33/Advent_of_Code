// Day 18: Boiling Boulders

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
    headerContentSections: [{ header: 'Day 18', content: 'Boiling Boulders' }]
  }
);

// ************************************************************************** //

import * as boiling_boulders from './boiling_boulders';

const val_1: number = boiling_boulders.surface_area(args.filename);
console.log('Overall surface area:', val_1);

const val_2: number = boiling_boulders.exterior_surface_area(args.filename);
console.log('Exterior surface area:', val_2);
