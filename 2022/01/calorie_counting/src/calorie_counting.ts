import * as fs from 'fs';

// ************************************************************************** //

// Get the index of the smalles value in the array
function idx_of_smallest(array: number[]): number {
  let idx: number = 0;
  let smallest: number = Number.MAX_SAFE_INTEGER;
  for (const i in array) {
    if (array[i] <= smallest) {
      smallest = array[i];
      idx = Number(i);
    }
  }

  return idx;
}

// ************************************************************************** //

/// First task.
export function max_calories(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  let max: number = 0;
  let count: number = 0;
  for (const line of lines) {
    if (line) {
      count += Number(line);
    } else {
      max = Math.max(max, count);
      count = 0;
    }
  }

  // Consider last group
  max = Math.max(max, count);

  return max;
}

/// Second task.
export function sum_of_top_three(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  let max_three: number[] = [0, 0, 0];
  let count: number = 0;
  for (const line of lines) {
    if (line) {
      count += Number(line);
    } else {
      const idx: number = idx_of_smallest(max_three);
      max_three[idx] = Math.max(max_three[idx], count);
      count = 0;
    }
  }

  // Consider last group
  const idx: number = idx_of_smallest(max_three);
  max_three[idx] = Math.max(max_three[idx], count);

  // Return sum
  return max_three.reduce<number>((accumulator, current) => {
    return accumulator + current;
  }, 0);
}
