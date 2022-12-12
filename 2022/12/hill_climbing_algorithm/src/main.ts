// Day 12: Hill Climbing Algorithm

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
      { header: 'Day 12', content: 'Hill Climbing Algorithm' }
    ]
  }
);

// ************************************************************************** //

import * as hill_climbing_algorithm from './hill_climbing_algorithm';

const val_1: number = hill_climbing_algorithm.shortest_path(args.filename);
console.log('Shortest path from start to end:', val_1);

const val_2: number = hill_climbing_algorithm.shortest_path_overall(
  args.filename
);
console.log('Shortest path from bottom to the top:', val_2);
