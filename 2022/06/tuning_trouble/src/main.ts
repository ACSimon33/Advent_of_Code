// Day 06: Tuning Trouble

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
    headerContentSections: [{ header: 'Day 06', content: 'Tuning Trouble' }]
  }
);

// ************************************************************************** //

import * as tuning_trouble from './tuning_trouble';

const val_1: number = tuning_trouble.find_start_marker(args.filename, 4);
console.log('Find start-of-package marker:', val_1);

const val_2: number = tuning_trouble.find_start_marker(args.filename, 14);
console.log('Find start-of-message marker:', val_2);
