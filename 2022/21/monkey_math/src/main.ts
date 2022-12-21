// Day 21: Monkey Math

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
    headerContentSections: [{ header: 'Day 21', content: 'Monkey Math' }]
  }
);

// ************************************************************************** //

import * as monkey_math from './monkey_math.js';

const val_1: number = monkey_math.evaluate(args.filename);
console.log('Evaluate root:', val_1);

const val_2: number = monkey_math.inverse_evaluate(args.filename);
console.log('Solve for humn:', val_2);
