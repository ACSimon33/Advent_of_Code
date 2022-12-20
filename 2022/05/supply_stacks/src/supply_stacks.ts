import * as fs from 'fs';

// ************************************************************************** //

// Interface for a generic stack
interface StackInterface<T> {
  push(crate: T): void;
  pop(): T | undefined;
  move_to(other: StackInterface<T>, amount: number): void;
  top(): T | undefined;
  reverse(): void;
}

// Class that implements a simple stack
class Stack<T> implements StackInterface<T> {
  private crates: T[];

  // Init an emtpy stack
  public constructor() {
    this.crates = [];
  }

  // Push to the stack
  public push(crate: T): void {
    this.crates.push(crate);
  }

  // Pop the top element from the stack
  public pop(): T | undefined {
    return this.crates.pop();
  }

  // Move a given amount of elements from this stack to another
  public move_to(
    other: StackInterface<T>,
    amount: number,
    retain_order: boolean = false
  ): void {
    let tmp: Stack<T> = new Stack<T>();
    for (let i: number = 0; i < amount; i++) {
      tmp.push(this.pop()!);
    }
    if (!retain_order) {
      tmp.reverse();
    }
    for (let i: number = 0; i < amount; i++) {
      other.push(tmp.pop()!);
    }
  }

  // Return the top element without popping it
  public top(): T | undefined {
    return this.crates.at(-1);
  }

  // Reverse the order of the stack
  public reverse(): void {
    this.crates = this.crates.reverse();
  }
}

// ************************************************************************** //

/// First & second task.
export function reorder_stacks(
  filename: string,
  retain_order: boolean
): string {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Calculate the amount of stacks and initialize them
  const amount_of_stacks: number = (lines[0]!.length + 1) / 4;
  const stacks: Stack<string>[] = [];

  for (let i: number = 0; i < amount_of_stacks; i++) {
    stacks.push(new Stack<string>());
  }

  // Parse the initial stack configuration
  for (const line of lines) {
    if (line.length == 0) {
      break;
    }

    for (let i: number = 0; i < amount_of_stacks; i++) {
      if (line.at(4 * i) == '[') {
        stacks[i]!.push(line.at(4 * i + 1)!);
      }
    }
  }

  // Reverse all stacks since we read them in the other way around
  for (const stack of stacks) {
    stack.reverse();
  }

  // Parse all reordering moves and apply them
  const regex: RegExp = /move ([0-9]+) from ([0-9]+) to ([0-9]+)/;
  for (const line of lines) {
    if (regex.test(line)) {
      const matches = line.match(regex);
      const amount: number = Number(matches?.at(1));
      const from: number = Number(matches?.at(2)) - 1;
      const to: number = Number(matches?.at(3)) - 1;

      stacks[from]!.move_to(stacks[to]!, amount, retain_order);
    }
  }

  // Return the final configuration
  return stacks.reduce((acc: string, stack: Stack<string>) => {
    return acc.concat(stack.top()!);
  }, '');
}
