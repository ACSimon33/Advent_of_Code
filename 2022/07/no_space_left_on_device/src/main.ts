// Day 07: No Space Left On Device

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
      { header: 'Day 07', content: 'No Space Left On Device' }
    ]
  }
);

// ************************************************************************** //

import * as no_space_left_on_device from './no_space_left_on_device';

const val_1: number = no_space_left_on_device.folders_below_100000(
  args.filename
);
console.log('Total sum of the folder sizes of folders below 100000:', val_1);

const val_2: number = no_space_left_on_device.find_folder_to_delete(
  args.filename
);
console.log('Size of folder which we want to delete:', val_2);
