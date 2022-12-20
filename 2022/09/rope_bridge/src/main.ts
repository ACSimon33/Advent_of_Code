// Day 09: Rope Bridge

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
    headerContentSections: [{ header: 'Day 09', content: 'Rope Bridge' }]
  }
);

// ************************************************************************** //

import * as rope_bridge from './rope_bridge.js';

const val_1: number = rope_bridge.tail_positions(args.filename, 2);
console.log('Rope of length 2:', val_1);

const val_2: number = rope_bridge.tail_positions(args.filename, 10);
console.log('Rope of length 10:', val_2);
