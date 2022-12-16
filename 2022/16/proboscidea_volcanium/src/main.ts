// Day 16: Proboscidea Volcanium

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
      { header: 'Day 16', content: 'Proboscidea Volcanium' }
    ]
  }
);

// ************************************************************************** //

import * as proboscidea_volcanium from './proboscidea_volcanium';

const val_1: number = proboscidea_volcanium.solution_1(args.filename);
console.log('Solution of task 1:', val_1);

const val_2: number = proboscidea_volcanium.solution_2(args.filename);
console.log('Solution of task 2:', val_2);
