// Day 16: Proboscidea Volcanium

// ************************************************************************** //

import { parse } from 'ts-command-line-args';

// Command line arguments
interface AoCArgs {
  filename: string;
  time: number;
  elefants: number;
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
    elefants: {
      type: Number,
      alias: 'e',
      defaultValue: 0,
      description: 'Number of elefants to help with opening the valves'
    },
    time: {
      type: Number,
      alias: 't',
      defaultValue: 30,
      description: 'Remaining time (in minutes)'
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

import * as proboscidea_volcanium from './proboscidea_volcanium.js';

const val_1: number = proboscidea_volcanium.max_pressure_release(
  args.filename,
  args.time,
  0
);
console.log('Maximum pressure release after', args.time, 'minutes:', val_1);

const val_2: number = proboscidea_volcanium.max_pressure_release(
  args.filename,
  args.time,
  args.elefants
);
console.log(
  'Maximum pressure release after',
  args.time,
  'minutes with',
  args.elefants,
  'elefants:',
  val_2
);
