// Day 22: Monkey Map

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
    headerContentSections: [{ header: 'Day 22', content: 'Monkey Map' }]
  }
);

// ************************************************************************** //

import * as monkey_map from './monkey_map.js';

const val_1: number = monkey_map.solution_1(args.filename);
console.log('Solution of task 1:', val_1);

// const val_2: number = monkey_map.solution_2(args.filename);
// console.log('Solution of task 2:', val_2);
