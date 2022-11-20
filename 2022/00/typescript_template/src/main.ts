// Day 0: Typescript Template

// ************************************************************************** //

import { parse } from 'ts-command-line-args';

// Command line arguments
interface AoCArgs {
  filename: string;
  help?: boolean;
}

// Args typed as AoCArgs
export const args = parse<AoCArgs>({
  filename: { type: String, alias: 'f', description: 'Input file (e.g. input/puzzle_input.txt)' },
  help: { type: Boolean, optional: true, alias: 'h', description: 'Prints this usage guide' }
}, {
  helpArg: 'help',
  headerContentSections: [{ header: 'Day 0', content: 'Typescript Template' }]
});

// ************************************************************************** //

import * as typescript_template from "./lib";

const val_1: number = typescript_template.solution_1(args.filename);
console.log(val_1);

let val_2: number = typescript_template.solution_2(args.filename);
console.log(val_2);
