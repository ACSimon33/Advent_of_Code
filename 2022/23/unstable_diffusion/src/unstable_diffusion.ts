import * as fs from 'fs';

// ************************************************************************** //

// Directions horizontal, vertical and diagonally
enum Direction {
  N = 0,
  NE = 1,
  E = 2,
  SE = 3,
  S = 4,
  SW = 5,
  W = 6,
  NW = 7
}

// 2D position
interface Position {
  row: number;
  col: number;
}

// Calculate opposite direction
function opposite(direction: Direction): Direction {
  return (direction + 4) % 8;
}

// Turn a certain number of times clockwise or counterclockwise
function turn(direction: Direction, turns: number): Direction {
  direction += turns;
  if (direction < 0) {
    direction += 8;
  }
  direction %= 8;
  return direction;
}

// Tile in the grove that is connected to all neighbouring tiles
class Claim {
  private readonly _detection_order: Direction[] = [
    Direction.N,
    Direction.S,
    Direction.W,
    Direction.E
  ];

  private _position: Position;
  private _neighbours: Claim[];
  private _elve: boolean;
  private _claimed_by: Direction[];

  // Create a tile with or without an elf occupying it
  public constructor(position: Position, elve: boolean) {
    this._position = position;
    this._neighbours = new Array<Claim>(8);
    this._elve = elve;
    this._claimed_by = [];
  }

  // Connect this tile with a neighbouring one
  public connect(direction: Direction, neighbour: Claim) {
    this._neighbours[direction] = neighbour;
    neighbour._neighbours[opposite(direction)] = this;
  }

  // Expand a boundary tile horizontally and/or vertically
  public expand_straight(): Claim[] {
    let claims: Claim[] = [];

    for (let d: Direction = 0; d < 8; d += 2) {
      if (!this._neighbours[d]) {
        let claim = new Claim(this.get_position(d), false);
        this.connect(d, claim);
        this._neighbours[turn(d, -2)]?.connect(turn(d, 1), claim);
        this._neighbours[turn(d, -1)]?.connect(turn(d, 2), claim);
        this._neighbours[turn(d, 2)]?.connect(turn(d, -1), claim);
        this._neighbours[turn(d, 1)]?.connect(turn(d, -2), claim);
        claims.push(claim);
      }
    }

    return claims;
  }

  // Expand a corner tile diagonally
  public expand_diagonally(): Claim[] {
    let claims: Claim[] = [];

    for (let d: Direction = 1; d < 8; d += 2) {
      if (!this._neighbours[d]) {
        let claim = new Claim(this.get_position(d), false);
        this.connect(d, claim);
        this._neighbours[turn(d, -1)]!.connect(turn(d, 1), claim);
        this._neighbours[turn(d, 1)]!.connect(turn(d, -1), claim);
        claims.push(claim);
      }
    }

    return claims;
  }

  // Check if the elf occupying this claim wants to move and where
  public detect(offset: number): boolean {
    if (!this._elve) {
      return false;
    }

    // Check if the elf is alone and return if that's the case
    let alone: boolean = true;
    for (let d: Direction = 0; d < 8; d++) {
      if (!this._neighbours[d]) {
        console.log(this);
      }
      alone &&= !this._neighbours[d]!.has_elve();
    }

    if (alone) {
      return false;
    }

    // Find new claim for the elf
    for (let i: number = 0; i < 4; i++) {
      const d: Direction = this._detection_order[(i + offset) % 4]!;
      if (this._neighbours[d]!.has_elve()) {
        continue;
      }
      if (this._neighbours[turn(d, -1)]!.has_elve()) {
        continue;
      }
      if (this._neighbours[turn(d, 1)]!.has_elve()) {
        continue;
      }
      this._neighbours[d]!.claim(d);
      break;
    }

    return true;
  }

  // Check if the tile was claimed by only one elf and move him
  public diffuse(): void {
    if (this._claimed_by.length == 1) {
      this._neighbours[this._claimed_by[0]!]!._elve = false;
      this._elve = true;
    }
    this._claimed_by = [];
  }

  // Check if this tile is claimed by an elf
  public has_elve(): boolean {
    return this._elve;
  }

  // Let an elf claim this tile
  private claim(direction: Direction): void {
    this._claimed_by.push(opposite(direction));
  }

  // Get the current or neighbouring position
  public get_position(d?: Direction): Position {
    if (d === undefined) {
      return this._position;
    }

    let pos: Position = { row: this._position.row, col: this._position.col };
    if (d == Direction.N || d == Direction.NW || d == Direction.NE) {
      pos.row--;
    }
    if (d == Direction.S || d == Direction.SW || d == Direction.SE) {
      pos.row++;
    }
    if (d == Direction.W || d == Direction.NW || d == Direction.SW) {
      pos.col--;
    }
    if (d == Direction.E || d == Direction.NE || d == Direction.SE) {
      pos.col++;
    }
    return pos;
  }
}

// Parse the initial grove with the elves
function parse_grove(lines: string[]): [Claim[], Claim[]] {
  const height = lines.length;
  const width = lines[0]!.length;

  // Parse grove
  let grove: Claim[] = new Array<Claim>(lines.length * lines[0]!.length);
  let boundary: Claim[] = new Array<Claim>();
  for (let i: number = 0; i < height; i++) {
    const line: string = lines[i]!;
    for (let j: number = 0; j < width; j++) {
      grove[i * width + j] = new Claim(
        { row: i, col: j },
        line.charAt(j) == '#'
      );

      if (i == 0 || i == height - 1 || j == 0 || j == width - 1) {
        boundary.push(grove[i * width + j]!);
      }
    }
  }

  // Connect claims
  for (let i: number = 0; i < height; i++) {
    for (let j: number = 0; j < width; j++) {
      const claim: Claim = grove[i * width + j]!;

      // West
      if (j > 0) {
        claim.connect(Direction.W, grove[i * width + (j - 1)]!);
      }
      // Northwest
      if (i > 0 && j > 0) {
        claim.connect(Direction.NW, grove[(i - 1) * width + (j - 1)]!);
      }
      // North
      if (i > 0) {
        claim.connect(Direction.N, grove[(i - 1) * width + j]!);
      }
      // NorthEast
      if (i > 0 && j < width - 1) {
        claim.connect(Direction.NE, grove[(i - 1) * width + (j + 1)]!);
      }
    }
  }

  return [grove, boundary];
}

// Simulate one step
function simulate_step(k: number, grove: Claim[], boundary: Claim[]): boolean {
  let new_boundary: Claim[] = [];
  let expanded: boolean = false;

  // Create a new boundary layer if necessary
  if (boundary.some((claim: Claim) => claim.has_elve())) {
    for (const claim of boundary) {
      const new_claims = claim.expand_straight();
      if (new_claims.length > 0) {
        new_boundary.push(...new_claims);
      }
    }
    for (const claim of boundary) {
      const new_claims = claim.expand_diagonally();
      if (new_claims.length > 0) {
        new_boundary.push(...new_claims);
      }
    }
    expanded = true;
  }

  // Check if at least one elf wants to move
  let elve_wants_to_move: boolean = false;
  for (const claim of grove) {
    const move = claim.detect(k % 4);
    elve_wants_to_move ||= move;
  }

  // Update the boundary tiles and grove tiles
  if (expanded) {
    boundary.splice(0);
    boundary.push(...new_boundary);
    grove.push(...new_boundary);
  }

  // Quick return if no elf wants to move
  if (!elve_wants_to_move) {
    return false;
  }

  // Move the elves
  for (const claim of grove) {
    claim.diffuse();
  }

  return true;
}

// ************************************************************************** //

/// First task.
export function empty_tiles(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse initial grove
  let [grove, boundary] = parse_grove(lines);

  // Simulate 10 steps
  for (let k: number = 0; k < 10; k++) {
    simulate_step(k, grove, boundary);
  }

  // Find bounding box
  let min_p: Position = { row: 0, col: 0 };
  let max_p: Position = { row: 0, col: 0 };
  let elves: number = 0;
  for (const claim of grove) {
    if (claim.has_elve()) {
      min_p.row = Math.min(min_p.row, claim.get_position().row);
      min_p.col = Math.min(min_p.col, claim.get_position().col);
      max_p.row = Math.max(max_p.row, claim.get_position().row);
      max_p.col = Math.max(max_p.col, claim.get_position().col);
      elves++;
    }
  }

  // Return amount of empty tiles
  return (max_p.row - min_p.row + 1) * (max_p.col - min_p.col + 1) - elves;
}

/// Second task.
export function steady_state(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse initial grove
  let [grove, boundary] = parse_grove(lines);

  // Simulate until we reach a steady state
  let k: number;
  for (k = 0; k < Number.POSITIVE_INFINITY; k++) {
    if (!simulate_step(k, grove, boundary)) {
      break;
    }
  }

  return k + 1;
}
