import * as fs from 'fs';

// ************************************************************************** //

// ************************************************************************** //

/// First task.
export function solution_1(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  return 42 + lines.length - lines.length;
}

/// Second task.
export function solution_2(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  return 43 + lines.length - lines.length;
}
