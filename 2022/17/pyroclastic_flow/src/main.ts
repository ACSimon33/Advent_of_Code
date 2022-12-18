// Day 17: Pyroclastic Flow

// ************************************************************************** //

import { parse } from 'ts-command-line-args';

// Command line arguments
interface AoCArgs {
  filename: string;
  rocks: number;
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
    rocks: {
      type: Number,
      alias: 'r',
      defaultValue: 2022,
      description: 'Amount of rocks'
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
    headerContentSections: [{ header: 'Day 17', content: 'Pyroclastic Flow' }]
  }
);

// ************************************************************************** //

import * as pyroclastic_flow from './pyroclastic_flow';

const val: number = pyroclastic_flow.cave_height(args.filename, args.rocks);
console.log('Cave height after', args.rocks, 'rocks:', val);
