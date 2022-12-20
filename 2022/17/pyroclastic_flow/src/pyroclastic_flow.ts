import * as fs from 'fs';

// ************************************************************************** //

// Superclass that contains a rock in the cave. The rock is stored in binary
// numbers (one for each row).
class Rock {
  private _volume: number[];

  // Create a rock
  protected constructor(volume: number[]) {
    this._volume = volume;
  }

  // Return the volme that this rock occupies
  public volume(): number[] {
    return this._volume;
  }

  // Return the height of this rock
  public height(): number {
    return this._volume.length;
  }

  // Shift the rock to the left
  public shift_left(): void {
    for (let y: number = 0; y < this._volume.length; y++) {
      this._volume[y] <<= 1;
    }
  }

  // Shift the rock to the right
  public shift_right(): void {
    for (let y: number = 0; y < this._volume.length; y++) {
      this._volume[y] >>>= 1;
    }
  }
}

// Horizontal rock:
// ####
class HorizontalRock extends Rock {
  public constructor(x_coord: number) {
    super([Math.pow(2, x_coord + 1) - Math.pow(2, x_coord - 3)]);
  }
}

// Vertical rock:
// #
// #
// #
// #
class VerticalRock extends Rock {
  public constructor(x_coord: number) {
    super([
      Math.pow(2, x_coord),
      Math.pow(2, x_coord),
      Math.pow(2, x_coord),
      Math.pow(2, x_coord)
    ]);
  }
}

// Cross rock:
//  #
// ###
//  #
class CrossRock extends Rock {
  public constructor(x_coord: number) {
    super([
      Math.pow(2, x_coord - 1),
      Math.pow(2, x_coord + 1) - Math.pow(2, x_coord - 2),
      Math.pow(2, x_coord - 1)
    ]);
  }
}

// L rock:
//   #
//   #
// ###
class LRock extends Rock {
  public constructor(x_coord: number) {
    super([
      Math.pow(2, x_coord + 1) - Math.pow(2, x_coord - 2),
      Math.pow(2, x_coord - 2),
      Math.pow(2, x_coord - 2)
    ]);
  }
}

// Block rock:
// ##
// ##
class BlockRock extends Rock {
  public constructor(x_coord: number) {
    super([
      Math.pow(2, x_coord + 1) - Math.pow(2, x_coord - 1),
      Math.pow(2, x_coord + 1) - Math.pow(2, x_coord - 1)
    ]);
  }
}

// Cave that is repesented via binary numbers. Binary and operations are used
// to check whether a rock overlaps with the walls / other rocks and binary or
// is used to insert rocks into the cave.
class Cave {
  private _empty: number;
  private _floor: number;
  private _volumes: number[];
  private _jets: boolean[];
  private _cur_jet: number;

  // Create an empty cave
  public constructor(width: number, jets: string) {
    // Init volume
    this._empty = Math.pow(2, width + 1) + 1;
    this._floor = Math.pow(2, width + 2) - 1;
    this._volumes = [this._floor];

    // Parse jets
    this._jets = jets.split('').map((jet: string) => jet == '<');
    this._cur_jet = 0;
  }

  // Return a string representation of the cave
  public toString(): string {
    let str: string = '';
    for (let y: number = this._volumes.length - 1; y >= 0; y--) {
      str += (this._volumes[y]! >>> 0).toString(2) + '\n';
    }

    return str.replaceAll('0', '.').replaceAll('1', '#');
  }

  // Add a given rock to the cave
  public add_rock(rock: Rock): number {
    let y: number = this._volumes.length + 3;
    this._volumes.push(...Array<number>(3 + rock.height()).fill(this._empty));

    // Lambda to check whether the rock overlaps with walls or other rocks
    const is_overlapping = (): boolean => {
      let overlapping: boolean = false;
      for (let i: number = 0; i < rock.height(); i++) {
        overlapping ||= Boolean(rock.volume()[i]! & this._volumes[y + i]!);
      }

      return overlapping;
    };

    // Move the rock until it overlaps with something
    while (!is_overlapping()) {
      this._jets[this._cur_jet] ? rock.shift_left() : rock.shift_right();
      if (is_overlapping()) {
        this._jets[this._cur_jet] ? rock.shift_right() : rock.shift_left();
      }

      if (++this._cur_jet == this._jets.length) {
        this._cur_jet = 0;
      }

      y--;
    }
    y++;

    // Insert the rock
    for (let i: number = 0; i < rock.volume().length; i++) {
      this._volumes[y + i] |= rock.volume()[i]!;
    }

    // Remove empty line from the cave
    while (this._volumes.at(-1) == this._empty) {
      this._volumes.pop();
    }

    // Return the current jet index
    return this._cur_jet;
  }

  // Return the current height off the cave
  public height(): number {
    return this._volumes.length - 1;
  }
}

// Add a rock of a certain type to the cave
function add_rock_to_cave(cave: Cave, type: number): number {
  switch (type) {
    case 0:
      return cave.add_rock(new HorizontalRock(5));
    case 1:
      return cave.add_rock(new CrossRock(5));
    case 2:
      return cave.add_rock(new LRock(5));
    case 3:
      return cave.add_rock(new VerticalRock(5));
    case 4:
      return cave.add_rock(new BlockRock(5));
  }

  return -1;
}

// ************************************************************************** //

/// First & second task.
export function cave_height(filename: string, rocks: number): number {
  const contents: string = fs.readFileSync(filename, 'utf8');

  // Init cave and jet counters
  let cave: Cave = new Cave(7, contents);
  let jet_counters: number[][] = new Array<Array<number>>(5);
  for (let i: number = 0; i < 5; i++) {
    jet_counters[i] = [];
  }

  let cycle_length: number = 0;
  let cycle_height: number = 0;
  let cylce_found: boolean = false;

  // Iterate through the rocks until a cycle is found
  let i: number;
  for (i = 0; i < rocks; i++) {
    const rock_type: number = i % 5;
    const jet: number = add_rock_to_cave(cave, rock_type);
    jet_counters[rock_type]!.push(jet);

    const jet_count: number = jet_counters[rock_type]!.filter(
      (j: number) => j == jet
    ).length;
    if (!cylce_found && jet_count == 2) {
      cycle_length = i;
      cycle_height = cave.height();
      cylce_found = true;
    } else if (jet_count == 3) {
      cycle_length = i - cycle_length;
      cycle_height = cave.height() - cycle_height;
      break;
    }
  }

  // Apply full cycles to reduce the amount of iterations
  const complete_cycles: number = Math.floor(
    Math.max(0, rocks - (i + 1)) / cycle_length
  );
  i += complete_cycles * cycle_length + 1;

  // Perform remaining iterations
  for (; i < rocks; i++) {
    add_rock_to_cave(cave, i % 5);
  }

  return cave.height() + complete_cycles * cycle_height;
}
