import * as fs from 'fs';

// ************************************************************************** //

// Greatest common divisor
function gcd(a: number, b: number): number {
  return b == 0 ? a : gcd(b, a % b);
}

// Least common multiple
function lcm(a: number, b: number): number {
  return (a * b) / gcd(a, b);
}

// ************************************************************************** //

// Vertical and horizontal directions
enum Direction {
  RIGHT = 0,
  DOWN = 1,
  LEFT = 2,
  UP = 3
}

// Position in a cartesian grid
interface Position {
  i: number;
  j: number;
}

// Blizzard consisting of one flag per direction
type Blizzard = [boolean, boolean, boolean, boolean];

// Basin that holds all precalculated values for the blizzard states and
// provides function to calculate the minimum time between two positions
class Basin {
  private _height: number;
  private _width: number;
  private _cycle: number;

  // Blizzards in space-time
  private _blizzards: Blizzard[][][];

  // Create the basin from an initial blizzard state. Precalculate all possible
  // Blizzard states from there.
  public constructor(map: string[]) {
    this._height = map.length - 2;
    this._width = map[0]!.length - 2;
    this._cycle = lcm(this._height, this._width);
    this._blizzards = new Array<Blizzard[][]>(this._cycle);

    // Parse initial blizzards
    this._blizzards[0] = new Array<Blizzard[]>(this._height);
    for (let i: number = 0; i < this._height; i++) {
      this._blizzards[0][i] = new Array<Blizzard>(this._width);
      for (let j: number = 0; j < this._width; j++) {
        this._blizzards[0]![i]![j] = this.parse(map[i + 1]!.charAt(j + 1));
      }
    }

    // Precompute all possible blizzard states
    for (let t: number = 1; t < this._cycle; t++) {
      this._blizzards[t] = new Array<Blizzard[]>(this._height);
      for (let i: number = 0; i < this._height; i++) {
        this._blizzards[t]![i] = new Array<Blizzard>(this._width);
        const up: number = i - 1;
        const down: number = (i + 1) % this._height;
        for (let j: number = 0; j < this._width; j++) {
          const left: number = j - 1;
          const right: number = (j + 1) % this._width;

          this._blizzards[t]![i]![j] = [
            this._blizzards[t - 1]!.at(i)!.at(left)![Direction.RIGHT],
            this._blizzards[t - 1]!.at(up)!.at(j)![Direction.DOWN],
            this._blizzards[t - 1]!.at(i)!.at(right)![Direction.LEFT],
            this._blizzards[t - 1]!.at(down)!.at(j)![Direction.UP]
          ];
        }
      }
    }
  }

  // Return the height of the basin
  public height(): number {
    return this._height;
  }

  // Return the width of the basin
  public width(): number {
    return this._width;
  }

  // Travese between two points in the basin and return the necessary time
  public traverse(offset: number, start: Position, end: Position): number {
    let positions: Set<number> = new Set<number>();
    let time: number = 0;

    // Simulate the first cycle, adding each possible start time
    while (time < this._cycle) {
      if (this.is_free((time + offset) % this._cycle, start)) {
        positions.add(this.to_index(start));
      }

      this.simulate(time++ + offset, positions);
      if (positions.has(this.to_index(end))) {
        break;
      }
    }

    // Simulate until we reach the end position
    while (!positions.has(this.to_index(end))) {
      this.simulate(time++ + offset, positions);
    }

    return time;
  }

  // Simulate a single step. From a given set of positions at a given time
  // calculate the set of positions where we can go next.
  private simulate(t: number, positions: Set<number>): void {
    let new_positions: Set<number> = new Set<number>();
    const next_t = (t + 1) % this._cycle;

    // Advance all current positions
    for (const idx of positions) {
      const pos = this.from_index(idx);

      // Move right
      const right: Position = { i: pos.i, j: pos.j + 1 };
      if (pos.j < this._width - 1 && this.is_free(next_t, right)) {
        new_positions.add(this.to_index(right));
      }

      // Move down
      const down: Position = { i: pos.i + 1, j: pos.j };
      if (pos.i < this._height - 1 && this.is_free(next_t, down)) {
        new_positions.add(this.to_index(down));
      }

      // Move left
      const left: Position = { i: pos.i, j: pos.j - 1 };
      if (pos.j > 0 && this.is_free(next_t, left)) {
        new_positions.add(this.to_index(left));
      }

      // Move up
      const up: Position = { i: pos.i - 1, j: pos.j };
      if (pos.i > 0 && this.is_free(next_t, up)) {
        new_positions.add(this.to_index(up));
      }

      // If waiting is not possible, remove position
      if (!this.is_free(next_t, pos)) {
        positions.delete(idx);
      }
    }

    // Add new positions
    new_positions.forEach((pos: number) => positions.add(pos));
  }

  // Check if a position is free at a given time
  private is_free(t: number, pos: Position): boolean {
    return !this._blizzards[t]![pos.i]![pos.j]!.some((x) => x);
  }

  // Translate the blizzards form the input string
  private parse(char: string): Blizzard {
    let blizzard: Blizzard = [false, false, false, false];
    switch (char) {
      case '>':
        blizzard[Direction.RIGHT] = true;
        break;
      case 'v':
        blizzard[Direction.DOWN] = true;
        break;
      case '<':
        blizzard[Direction.LEFT] = true;
        break;
      case '^':
        blizzard[Direction.UP] = true;
        break;
    }

    return blizzard;
  }

  // Turn a position into a unique index
  private to_index(pos: Position): number {
    return pos.i * this._width + pos.j;
  }

  // Recover a position form its unique index
  private from_index(idx: number): Position {
    return { i: Math.floor(idx / this._width), j: idx % this._width };
  }
}

// ************************************************************************** //

/// First task.
export function traverse(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Prepare basin
  const basin: Basin = new Basin(lines);
  const entry: Position = { i: 0, j: 0 };
  const exit: Position = { i: basin.height() - 1, j: basin.width() - 1 };

  // Traverse the basin
  let time: number = 1;
  time += basin.traverse(time, entry, exit) + 1;

  return time;
}

/// Second task.
export function traverse_three_times(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Prepare basin
  const basin: Basin = new Basin(lines);
  const entry: Position = { i: 0, j: 0 };
  const exit: Position = { i: basin.height() - 1, j: basin.width() - 1 };

  // Traverse the basin three times
  let time: number = 1;
  time += basin.traverse(time, entry, exit) + 2;
  time += basin.traverse(time, exit, entry) + 2;
  time += basin.traverse(time, entry, exit) + 1;

  return time;
}
