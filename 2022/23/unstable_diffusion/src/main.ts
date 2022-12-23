// Day 23: Unstable Diffusion

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
    headerContentSections: [{ header: 'Day 23', content: 'Unstable Diffusion' }]
  }
);

// ************************************************************************** //

import * as unstable_diffusion from './unstable_diffusion.js';

const val_1: number = unstable_diffusion.empty_tiles(args.filename);
console.log('Empty ground tiles after 10 steps:', val_1);

const val_2: number = unstable_diffusion.steady_state(args.filename);
console.log('Steps until we reach steady state:', val_2);
