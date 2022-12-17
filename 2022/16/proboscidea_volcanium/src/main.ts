// Day 16: Proboscidea Volcanium

// ************************************************************************** //

import { parse } from 'ts-command-line-args';

// Command line arguments
interface AoCArgs {
  filename: string;
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

const val_1: number = proboscidea_volcanium.max_pressure_release(
  args.filename, 0
);
console.log('Maximum pressure release:', val_1);

const val_2: number = proboscidea_volcanium.max_pressure_release(
  args.filename,
  args.elefants
);
console.log('Maximum pressure release with', args.elefants, 'elefants:', val_2);
