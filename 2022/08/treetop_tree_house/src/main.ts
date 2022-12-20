// Day 08: Treetop Tree House

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
    headerContentSections: [{ header: 'Day 08', content: 'Treetop Tree House' }]
  }
);

// ************************************************************************** //

import * as treetop_tree_house from './treetop_tree_house.js';

const val_1: number = treetop_tree_house.number_of_visible_trees(args.filename);
console.log('Number of visible trees:', val_1);

const val_2: number = treetop_tree_house.max_scenic_score(args.filename);
console.log('Highest scenic score:', val_2);
