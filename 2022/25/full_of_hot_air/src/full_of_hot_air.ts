import * as fs from 'fs';

// ************************************************************************** //

// SNAFU number that can be added up
class SNAFU {
  private _digits: number[];

  // Create a SNAFU number from the given digits
  public constructor(digits: number[]) {
    this._digits = digits;

    // Remove leading zeros
    while (this._digits.at(-1)! == 0 && this._digits.length > 1) {
      this._digits.pop();
    }
  }

  // Create SNAFU number from a given string
  static from(str: string): SNAFU {
    return new SNAFU(
      str
        .split('')
        .map((char: string): number => {
          switch (char) {
            case '=':
              return -2;
            case '-':
              return -1;
            default:
              return Number(char);
          }
        })
        .reverse()
    );
  }

  // Add this SNAFU number to another one
  public add(other: SNAFU): SNAFU {
    const max_digits = Math.max(this._digits.length, other._digits.length) + 1;
    let digits: number[] = new Array<number>(max_digits);
    digits.fill(0);

    for (let i: number = 0; i < max_digits - 1; i++) {
      // Add
      if (i < this._digits.length) {
        digits[i] += this._digits[i]!;
      }
      if (i < other._digits.length) {
        digits[i] += other._digits[i]!;
      }

      // Carry
      while (digits[i]! < -2) {
        digits[i + 1] -= 1;
        digits[i] += 5;
      }
      while (digits[i]! > 2) {
        digits[i + 1] += 1;
        digits[i] -= 5;
      }
    }

    return new SNAFU(digits);
  }

  // Convert SNAFU number to a string
  public to_string(): string {
    return this._digits
      .map((digit: number): string => {
        switch (digit) {
          case -2:
            return '=';
          case -1:
            return '-';
          default:
            return digit.toString();
        }
      })
      .reverse()
      .join('');
  }
}

// ************************************************************************** //

/// First task.
export function sum_of_SNAFU_numbers(filename: string): string {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse SNAFU numbers
  const snafu_numbers: SNAFU[] = lines.map((str: string) => SNAFU.from(str));

  // Sum up SNAFU numbers and return the result as a string
  return snafu_numbers
    .reduce((acc: SNAFU, current: SNAFU): SNAFU => {
      return acc.add(current);
    }, new SNAFU([0]))
    .to_string();
}
