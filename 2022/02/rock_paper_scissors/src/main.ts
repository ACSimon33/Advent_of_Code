// Day 02: Rock Paper Scissors

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
      { header: 'Day 02', content: 'Rock Paper Scissors' }
    ]
  }
);

// ************************************************************************** //

import * as rock_paper_scissors from './rock_paper_scissors';

const points_1: number = rock_paper_scissors.guess_instructioons(args.filename);
console.log('Your total points with X=Rock, Y=Paper, Z=Scissors:', points_1);

const val_2: number = rock_paper_scissors.follow_instructioons(args.filename);
console.log('Your total points with X=Lose, Y=Draw, Z=Win:', val_2);
