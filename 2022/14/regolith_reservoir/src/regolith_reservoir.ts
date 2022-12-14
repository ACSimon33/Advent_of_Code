import { add } from 'benny';
import * as fs from 'fs';
import { threadId } from 'worker_threads';

// ************************************************************************** //

// Possible materials
enum Material {
  AIR,
  ROCK,
  FALLING_SAND,
  STATIONARY_SAND
}

// Cave which represents a 2D slice of the cave
class Cave {
  private _grid: Material[][];
  private _min_x: number;
  private _max_x: number;
  private _max_y: number;
  private _source: number;

  // Construct the cave from the input string
  public constructor(
    slices: string[],
    source: number,
    add_floor: boolean = false
  ) {
    // Find bounds of the cave
    this._source = source;
    this._min_x = source;
    this._max_x = source;
    this._max_y = 0;
    for (const path of slices) {
      for (const corner of path.matchAll(/([0-9]+),([0-9]+)/g)) {
        this._min_x = Math.min(this._min_x, Number(corner[1]));
        this._max_x = Math.max(this._max_x, Number(corner[1]));
        this._max_y = Math.max(this._max_y, Number(corner[2]));
      }
    }

    // Adjust boundaries to account for an infinite floor
    if (add_floor) {
      this._max_y += 2;
      this._min_x = Math.min(this._min_x, this._source - this._max_y);
      this._max_x = Math.max(this._max_x, this._source + this._max_y);
    }

    // Init grid
    this._grid = new Array<Material[]>(this._max_y + 1);
    for (let i: number = 0; i < this._max_y + 1; i++) {
      this._grid[i] = new Array<Material>(this._max_x - this._min_x + 1).fill(
        Material.AIR
      );
    }

    // Parse cave slice
    for (const path of slices) {
      const lines: number[][] = path.split(' -> ').map((coords: string) => {
        return coords.split(',').map((coord: string) => Number(coord));
      });
      for (let i: number = 1; i < lines.length; i++) {
        if (lines[i - 1][1] == lines[i][1]) {
          // Horizontal
          const start: number = Math.min(lines[i][0], lines[i - 1][0]);
          const end: number = Math.max(lines[i][0], lines[i - 1][0]);
          for (let j: number = start; j <= end; j++) {
            this._grid[lines[i][1]][j - this._min_x] = Material.ROCK;
          }
        } else if (lines[i - 1][0] == lines[i][0]) {
          // Vertical
          const start: number = Math.min(lines[i][1], lines[i - 1][1]);
          const end: number = Math.max(lines[i][1], lines[i - 1][1]);
          for (let j: number = start; j <= end; j++) {
            this._grid[j][lines[i][0] - this._min_x] = Material.ROCK;
          }
        }
      }
    }

    // Add infinite floor
    if (add_floor) {
      this._grid[this._max_y].fill(Material.ROCK);
    }
  }

  // Fill the cave with sand until the sand falls into the abyss or the source
  // is blocked
  public fill_cave(): number {
    let sand_counter: number = 0;
    while (true) {
      let s: number[] = [0, this._source];

      // Check if source is blocked
      if (this._grid[s[0]][s[1] - this._min_x] != Material.AIR) {
        break;
      }

      let stationary: boolean = false;
      while (true) {
        // Check boundary
        if (s[0] >= this._max_y || s[1] <= this._min_x || s[1] >= this._max_x) {
          break;
        }

        // Check below
        if (this._grid[s[0] + 1][s[1] - this._min_x] == Material.AIR) {
          s[0]++;
          continue;
        }

        // Check left
        if (this._grid[s[0] + 1][s[1] - 1 - this._min_x] == Material.AIR) {
          s[0]++;
          s[1]--;
          continue;
        }

        // Check right
        if (this._grid[s[0] + 1][s[1] + 1 - this._min_x] == Material.AIR) {
          s[0]++;
          s[1]++;
          continue;
        }

        stationary = true;
        break;
      }

      // Add sand to the cave or break
      if (stationary) {
        this._grid[s[0]][s[1] - this._min_x] = Material.STATIONARY_SAND;
        sand_counter++;
      } else {
        break;
      }
    }

    return sand_counter;
  }

  // Create an 2D image of the cave
  public toString(): string {
    let str: string = '';

    for (const line of this._grid) {
      for (const point of line) {
        switch (point) {
          case Material.AIR:
            str += '.';
            break;
          case Material.ROCK:
            str += '#';
            break;
          case Material.FALLING_SAND:
            str += '~';
            break;
          case Material.STATIONARY_SAND:
            str += 'o';
            break;
        }
      }
      str += '\n';
    }

    return str;
  }
}

// ************************************************************************** //

/// First & second task.
export function fill_cave(filename: string, add_floor: boolean): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  let cave: Cave = new Cave(lines, 500, add_floor);
  // console.log(cave.toString());

  const sand: number = cave.fill_cave();
  // console.log(cave.toString())

  return sand;
}
