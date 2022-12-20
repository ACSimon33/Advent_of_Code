// Day 11: Monkey in the Middle

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
      { header: 'Day 11', content: 'Monkey in the Middle' }
    ]
  }
);

// ************************************************************************** //

import * as monkey_in_the_middle from './monkey_in_the_middle.js';

const val_1: number = monkey_in_the_middle.with_worry_reduction(args.filename);
console.log('Monkey business after 20 rounds with worry reduction:', val_1);

const val_2: number = monkey_in_the_middle.without_worry_reduction(
  args.filename
);
console.log('Monkey business after 10000 rounds without reduction:', val_2);
