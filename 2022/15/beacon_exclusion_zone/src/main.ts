// Day 15: Beacon Exclusion Zone

// ************************************************************************** //

import { parse } from 'ts-command-line-args';

// Command line arguments
interface AoCArgs {
  filename: string;
  row: number;
  size: number;
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
    row: {
      type: Number,
      alias: 'r',
      defaultValue: 2000000,
      description: 'Row which is scanned (task 1)'
    },
    size: {
      type: Number,
      defaultValue: 4000000,
      alias: 's',
      description: 'Size of the scanned region (task 2)'
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
      { header: 'Day 15', content: 'Beacon Exclusion Zone' }
    ]
  }
);

// ************************************************************************** //

import * as beacon_exclusion_zone from './beacon_exclusion_zone';

const val_1: number = beacon_exclusion_zone.invalid_positions(
  args.filename,
  args.row
);
console.log("Positions that can't contain beacon:", val_1);

const val_2: number = beacon_exclusion_zone.tuning_frequency(
  args.filename,
  args.size
);
console.log('Tuning frequency of the beacon:', val_2);
