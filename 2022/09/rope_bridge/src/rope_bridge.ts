import * as fs from 'fs';

// ************************************************************************** //

// Directions
enum Direction {
  U,
  D,
  L,
  R
}

// Postion
interface Position {
  row: number;
  col: number;
}

// Rope with arbitrary length
class Rope {
  private _knots: Position[][];
  private _bl: Position;
  private _tr: Position;

  // Create a rope with the given length
  public constructor(length: number) {
    this._knots = [];
    for (let i: number = 0; i < length; i++) {
      this._knots.push([{ row: 0, col: 0 }]);
    }
    this._bl = { row: 0, col: 0 };
    this._tr = { row: 0, col: 0 };
  }

  // Take a certain number of steps into one direction
  public move(dir: Direction, steps: number): void {
    for (let i = 0; i < steps; i++) {
      // Move the head of the rope
      this._knots[0]!.push({ ...this._knots[0]!.at(-1)! });
      switch (dir) {
        case Direction.U:
          this._knots[0]!.at(-1)!.row++;
          if (this._knots[0]!.at(-1)!.row > this._tr.row) {
            this._tr.row = this._knots[0]!.at(-1)!.row;
          }
          break;

        case Direction.D:
          this._knots[0]!.at(-1)!.row--;
          if (this._knots[0]!.at(-1)!.row < this._bl.row) {
            this._bl.row = this._knots[0]!.at(-1)!.row;
          }
          break;

        case Direction.L:
          this._knots[0]!.at(-1)!.col--;
          if (this._knots[0]!.at(-1)!.col < this._bl.col) {
            this._bl.col = this._knots[0]!.at(-1)!.col;
          }
          break;

        case Direction.R:
          this._knots[0]!.at(-1)!.col++;
          if (this._knots[0]!.at(-1)!.col > this._tr.col) {
            this._tr.col = this._knots[0]!.at(-1)!.col;
          }
          break;
      }

      // Drag the tail of the rope
      this.apply_physics();
    }
  }

  // Calculate the number of positions the tail of the rope visited
  public calculate_tail_positions(): number {
    return new Set(
      this._knots.at(-1)!.map((pos: Position): string => {
        return JSON.stringify(pos);
      })
    ).size;
  }

  // Print the current rope
  public print(): void {
    console.log();
    for (let i: number = this._tr.row; i >= this._bl.row; i--) {
      let line: string = '';
      for (let j: number = this._bl.col; j <= this._tr.col; j++) {
        let found: boolean = false;
        for (const k in this._knots) {
          const pos = this._knots[k]!.at(-1)!;
          if (pos.row == i && pos.col == j) {
            line += k as string;
            found = true;
            break;
          }
        }
        if (!found) {
          line += '.';
        }
      }

      console.log(line);
    }
  }

  // Let the rope converge to a steady state
  private apply_physics(): void {
    for (let i: number = 1; i < this._knots.length; i++) {
      const row_diff: number =
        this._knots[i - 1]!.at(-1)!.row - this._knots[i]!.at(-1)!.row;
      const col_diff: number =
        this._knots[i - 1]!.at(-1)!.col - this._knots[i]!.at(-1)!.col;

      this._knots[i]!.push({ ...this._knots[i]!.at(-1)! });

      if (Math.abs(row_diff) == 2) {
        this._knots[i]!.at(-1)!.row += Math.sign(row_diff);
        if (Math.abs(col_diff) >= 1) {
          this._knots[i]!.at(-1)!.col += Math.sign(col_diff);
        }
      } else if (Math.abs(col_diff) > 1) {
        this._knots[i]!.at(-1)!.col += Math.sign(col_diff);
        if (Math.abs(row_diff) >= 1) {
          this._knots[i]!.at(-1)!.row += Math.sign(row_diff);
        }
      }
    }
  }
}

// ************************************************************************** //

/// First & second task.
export function tail_positions(filename: string, rope_length: number): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Create a rope and move it according to the instructions
  let rope: Rope = new Rope(rope_length);
  for (const line of lines) {
    const move = line.match(/([UDLR]) ([0-9]*)/)!;
    rope.move(Direction[move[1] as keyof typeof Direction], Number(move[2]));
  }

  return rope.calculate_tail_positions();
}
