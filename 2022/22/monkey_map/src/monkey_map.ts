import * as fs from 'fs';

// ************************************************************************** //

enum Material {
  VOID,
  AIR,
  WALL
}

enum Direction {
  RIGHT = 0,
  DOWN = 1,
  LEFT = 2,
  UP = 3
}

interface Position {
  row: number;
  col: number;
}

function opposite(direction: Direction): Direction {
  return (direction + 2) % 4;
}

function turn(direction: Direction, turns: number): Direction {
  direction += turns;
  if (direction < 0) {
    direction += 4;
  }
  direction %= 4;
  return direction;
}

// Element in a doubly linked list
class Tile {
  private _position: Position;
  private _material: Material;
  private _neighbours: Tile[];
  private _new_directions: Direction[];

  // Create an unlinked element with a value
  public constructor(position: Position, material: Material) {
    this._position = position;
    this._material = material;
    this._neighbours = new Array<Tile>(4);
    this._new_directions = new Array<Direction>(4);
  }

  // Connect the current tile with a tile on the left
  public connect_left(
    left: Tile,
    new_direction: Direction = Direction.LEFT
  ): void {
    this._neighbours[Direction.LEFT] = left;
    this._new_directions[Direction.LEFT] = new_direction;
    left._neighbours[opposite(new_direction)] = this;
    left._new_directions[opposite(new_direction)] = Direction.RIGHT;
  }

  // Connect the current tile with a tile above
  public connect_up(up: Tile, new_direction: Direction = Direction.UP): void {
    this._neighbours[Direction.UP] = up;
    this._new_directions[Direction.UP] = new_direction;
    up._neighbours[opposite(new_direction)] = this;
    up._new_directions[opposite(new_direction)] = Direction.DOWN;
  }

  // Return the position
  public position(): Position {
    return this._position;
  }

  // Return the material
  public material(): Material {
    return this._material;
  }

  public neighbour(direction: Direction): [Tile, Direction] {
    switch (direction) {
      case Direction.LEFT:
        return [this.left(), this._new_directions[Direction.LEFT]!];
      case Direction.UP:
        return [this.up(), this._new_directions[Direction.UP]!];
      case Direction.RIGHT:
        return [this.right(), this._new_directions[Direction.RIGHT]!];
      case Direction.DOWN:
        return [this.down(), this._new_directions[Direction.DOWN]!];
    }
  }

  // Return the left tile
  private left(): Tile {
    const left = this._neighbours[Direction.LEFT]!;
    if (left.material() == Material.VOID) {
      return left.left();
    }

    return left;
  }

  // Return the right tile
  private right(): Tile {
    const right = this._neighbours[Direction.RIGHT]!;
    if (right.material() == Material.VOID) {
      return right.right();
    }

    return right;
  }

  // Return the up tile
  private up(): Tile {
    const up = this._neighbours[Direction.UP]!;
    if (up.material() == Material.VOID) {
      return up.up();
    }

    return up;
  }

  // Return the down tile
  private down(): Tile {
    const down = this._neighbours[Direction.DOWN]!;
    if (down.material() == Material.VOID) {
      return down.down();
    }

    return down;
  }
}

function parse_map(map: string): [Tile[][], number, number] {
  const lines = map.split(/\r?\n/);
  const height = lines.length;
  const width = lines.reduce((acc: number, line: string) => {
    return Math.max(acc, line.length);
  }, 0);

  // Parse tiles
  let tiles: Tile[][] = new Array<Tile[]>(height);
  for (const [i, line] of lines.entries()) {
    let arr: Tile[] = new Array<Tile>(width);
    for (let j: number = 0; j < line.length; j++) {
      switch (line.charAt(j)) {
        case '.':
          arr[j] = new Tile({ row: i + 1, col: j + 1 }, Material.AIR);
          break;
        case '#':
          arr[j] = new Tile({ row: i + 1, col: j + 1 }, Material.WALL);
          break;
        default:
          arr[j] = new Tile({ row: i + 1, col: j + 1 }, Material.VOID);
      }
    }

    for (let j: number = line.length; j < width; j++) {
      arr[j] = new Tile({ row: i + 1, col: j + 1 }, Material.VOID);
    }

    tiles[i] = arr;
  }

  return [tiles, height, width];
}

function parse_path(path: string): [number[], number[]] {
  const moves: number[] = path!
    .split(/[LR]+/)
    .map((str: string) => Number(str));
  const turns: number[] = path!
    .split(/[0-9]+/)
    .map((str: string) => (str == 'L' ? -1 : 1));
  turns.shift();
  turns.pop();

  return [moves, turns];
}

function walk(tiles: Tile[][], path: string): [Position, Direction] {
  // Find start tile
  let current: Tile = tiles[0]![0]!;
  for (const tile of tiles[0]!) {
    if (tile.material() == Material.AIR) {
      current = tile;
      break;
    }
  }

  // Parse path
  const [moves, turns] = parse_path(path);

  let current_direction: Direction = Direction.RIGHT;
  for (let k: number = 0; k < moves.length; k++) {
    // Move
    for (let m: number = 0; m < moves[k]!; m++) {
      const [neighbour, direction] = current.neighbour(current_direction);
      if (neighbour.material() == Material.WALL) {
        break;
      }
      current = neighbour;
      current_direction = direction;
    }

    // Turn
    if (k < turns.length) {
      current_direction = turn(current_direction, turns[k]!);
    }
  }

  return [current.position(), current_direction];
}

// ************************************************************************** //

/// First task.
export function solution_1(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const [map, path] = [...contents.split(/\r?\n\r?\n/)];

  // Parse tiles
  const [tiles, height, width] = parse_map(map!);

  // Connect horizontally and vertically (2D)
  for (let i: number = 0; i < height; i++) {
    for (let j: number = 0; j < width; j++) {
      const tile: Tile = tiles[i]![j]!;
      tile.connect_left(tiles[i]!.at(j - 1)!);
      tile.connect_up(tiles.at(i - 1)![j]!);
    }
  }

  // Walk the path and return the password
  const [position, current_direction] = walk(tiles, path!);
  return 1000 * position.row + 4 * position.col + current_direction;
}

/// Second task.
export function solution_2(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const [map, path] = [...contents.split(/\r?\n\r?\n/)];

  // Parse tiles
  const [tiles, height, width] = parse_map(map!);

  // Fold up cube and connect the tiles accordingly
  for (let i: number = 0; i < height; i++) {
    for (let j: number = 0; j < width; j++) {
      // TODO
    }
  }

  // Walk the path and return the password
  const [position, current_direction] = walk(tiles, path!);
  return 1000 * position.row + 4 * position.col + current_direction;
}
