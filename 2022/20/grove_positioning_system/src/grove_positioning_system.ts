import * as fs from 'fs';

// ************************************************************************** //

// Element in a doubly linked list
class Element {
  private _value: number;
  private _previous: Element | null;
  private _next: Element | null;

  // Create an unlinked element with a value
  public constructor(value: number) {
    this._value = value;
    this._previous = null;
    this._next = null;
  }

  // Connect the current element with a given predecessor
  public connect(previous: Element): void {
    this._previous = previous;
    previous._next = this;
  }

  // Decrypt value
  public decrypt(key: number): void {
    this._value *= key;
  }

  // Return the value
  public value(): number {
    return this._value;
  }

  // Return the previous element
  public previous(): Element {
    return this._previous!;
  }

  // Return the next element
  public next(): Element {
    return this._next!;
  }
}

// Calculate the cooredinated by mixing the list of values
function get_coords(list: Element[], key: number = 1, n: number = 1): number[] {
  // Apply decryption key
  for (let elem of list) {
    elem.decrypt(key);
  }

  // Mix list n times
  for (let k: number = 0; k < n; k++) {
    for (let elem of list) {
      // Calculate the amount of moves
      let moves = elem.value() % (list.length - 1);
      if (moves > list.length / 2) {
        moves -= list.length - 1;
      } else if (moves < -list.length / 2) {
        moves += list.length - 1;
      }

      // Quick return
      if (moves == 0) {
        continue;
      }

      // Remove current item from the list
      elem.next().connect(elem.previous());

      // Insert current element at the correct position
      let other: Element = elem;
      if (moves > 0) {
        for (let i: number = 0; i < moves; i++) {
          other = other.next();
        }
        other.next().connect(elem);
        elem.connect(other);
      } else {
        for (let i: number = 0; i > moves; i--) {
          other = other.previous();
        }
        elem.connect(other.previous());
        other.connect(elem);
      }
    }
  }

  // Find coordinates
  const coords: number[] = new Array<number>(3);
  for (let elem of list) {
    if (elem.value() == 0) {
      let iter: Element = elem;
      for (let i: number = 1; i <= 3000; i++) {
        iter = iter.next();
        switch (i) {
          case 1000:
            coords[0] = iter.value();
            break;
          case 2000:
            coords[1] = iter.value();
            break;
          case 3000:
            coords[2] = iter.value();
            break;
        }
      }
      break;
    }
  }

  return coords;
}

// ************************************************************************** //

/// First task.
export function calc_coordinates_sum(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse list of numbers and link them together in a loop
  const list: Element[] = lines.map((str: string) => new Element(Number(str)));
  for (let i: number = 0; i < list.length; i++) {
    list.at(i)!.connect(list.at(i - 1)!);
  }

  // Calculate coordinate and sum them up
  const coords = get_coords(list);
  return coords[0]! + coords[1]! + coords[2]!;
}

/// Second task.
export function calc_coordinates_sum_with_decryption(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse list of numbers and link them together in a loop
  const list: Element[] = lines.map((str: string) => new Element(Number(str)));
  for (let i: number = 0; i < list.length; i++) {
    list.at(i)!.connect(list.at(i - 1)!);
  }

  // Calculate coordinate and sum them up
  const coords = get_coords(list, 811589153, 10);
  return coords[0]! + coords[1]! + coords[2]!;
}
