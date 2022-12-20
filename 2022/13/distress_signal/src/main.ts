// Day 13: Distress Signal

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
    headerContentSections: [{ header: 'Day 13', content: 'Distress Signal' }]
  }
);

// ************************************************************************** //

import * as distress_signal from './distress_signal.js';

const val_1: number = distress_signal.correct_order(args.filename);
console.log('Index sum of correct signal pairs:', val_1);

const val_2: number = distress_signal.decoder_key(args.filename);
console.log('Decoder key:', val_2);
