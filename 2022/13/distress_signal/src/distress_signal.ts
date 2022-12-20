import * as fs from 'fs';

// ************************************************************************** //

// Order flag
enum Order {
  CORRECT = -1,
  FALSE = 1,
  INDEFINITE = 0
}

// Class to parse and store the signal
class Signal {
  private _tokens: (Signal | number)[];

  // Parse signal from a given string
  public constructor(str: string, start: number, end?: number) {
    this._tokens = [];

    // Deduce end index if not given
    const n = end ?? str.length;

    for (let i: number = start; i < n; i++) {
      if (str.charAt(i) == ',' || str.charAt(i) == ']') {
        // Skip commas and closing brackets
        continue;
      }

      if (str.charAt(i) == '[') {
        // Parse a sub signal
        let open_brackets: number = 1;
        for (let j: number = i + 1; j < n; j++) {
          if (str.charAt(j) == '[') {
            open_brackets++;
          } else if (str.charAt(j) == ']') {
            open_brackets--;
          }

          if (open_brackets == 0) {
            this._tokens.push(new Signal(str, i + 1, j));
            i = j;
            break;
          }
        }
      } else {
        // Parse a number
        let last_token: boolean = true;
        for (let j: number = i + 1; j < n; j++) {
          if (str.charAt(j) == ',') {
            this._tokens.push(Number(str.substring(i, j)));
            last_token = false;
            i = j;
            break;
          }
        }

        if (last_token) {
          this._tokens.push(Number(str.substring(i, end)));
          i = n;
        }
      }
    }
  }

  // Compare two signals and return an order flag
  public compare(other: Signal): Order {
    let intermediate: Order = Order.INDEFINITE;
    for (let i: number = 0; i < this._tokens.length; i++) {
      if (i >= other._tokens.length) {
        return Order.FALSE; // Second list ran out of items first
      }

      if (this._tokens[i] instanceof Signal) {
        const first: Signal = this._tokens[i] as Signal;
        if (other._tokens[i] instanceof Signal) {
          const second: Signal = other._tokens[i] as Signal;
          intermediate = first.compare(second); // (signal vs. signal)

          // Return if there is a definite result
          if (intermediate != Order.INDEFINITE) {
            return intermediate;
          }
        } else {
          const second: Signal = new Signal(other._tokens[i]!.toString(), 0);
          intermediate = first.compare(second); // (signal vs. number)

          // Return if there is a definite result
          if (intermediate != Order.INDEFINITE) {
            return intermediate;
          }
        }
      } else {
        if (other._tokens[i] instanceof Signal) {
          const first: Signal = new Signal(this._tokens[i]!.toString(), 0);
          const second: Signal = other._tokens[i] as Signal;
          intermediate = first.compare(second); // (number vs. signal)

          // Return if there is a definite result
          if (intermediate != Order.INDEFINITE) {
            return intermediate;
          }
        } else {
          // (number vs. number)
          if (this._tokens[i]! < other._tokens[i]!) {
            return Order.CORRECT;
          } else if (this._tokens[i]! > other._tokens[i]!) {
            return Order.FALSE;
          }
        }
      }
    }

    if (this._tokens.length < other._tokens.length) {
      return Order.CORRECT; // First list ran out of items first
    }

    return Order.INDEFINITE;
  }

  // Return a string representation of the signal
  public toString(): string {
    return '[' + this._tokens.join(',') + ']';
  }
}

// ************************************************************************** //

/// First task.
export function correct_order(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');

  // Parse signals in pairs
  const signal_pairs = contents.split(/\r?\n\r?\n/);
  let signals: Signal[][] = [];
  for (const pair of signal_pairs) {
    signals.push(
      pair.split(/\r?\n/).map((str: string): Signal => {
        return new Signal(str, 1, str.length - 1);
      })
    );
  }

  // Add indices of signal pairs in correct order
  return signals.reduce((acc: number, pair: Signal[], idx: number) => {
    return acc + (pair[0]!.compare(pair[1]!) == Order.CORRECT ? idx + 1 : 0);
  }, 0);
}

/// Second task.
export function decoder_key(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse signals
  let signals: Signal[] = [];
  for (const line of lines) {
    if (line.length > 0) {
      signals.push(new Signal(line, 1, line.length - 1));
    }
  }

  // Add divider packages and sort signals
  signals.push(new Signal('[[2]]', 1, 4));
  signals.push(new Signal('[[6]]', 1, 4));
  signals.sort((s1: Signal, s2: Signal) => s1.compare(s2));

  // Multiply indices of divider packages and return the decoder key
  return signals.reduce((decoder_key: number, signal: Signal, idx: number) => {
    const str: string = signal.toString();
    return decoder_key * (str == '[[2]]' || str == '[[6]]' ? idx + 1 : 1);
  }, 1);
}
