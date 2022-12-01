// Day 01: Calorie Counting

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
    headerContentSections: [{ header: 'Day 01', content: 'Calorie Counting' }]
  }
);

// ************************************************************************** //

import * as calorie_counting from './calorie_counting';

const max_cal: number = calorie_counting.max_calories(args.filename);
console.log('Max calories:', max_cal);

const top_three_cal: number = calorie_counting.sum_of_top_three(args.filename);
console.log('Sum of top three calories:', top_three_cal);
