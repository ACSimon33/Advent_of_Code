import * as fs from 'fs';

// ************************************************************************** //

// Item with a worry level which uses modulo arithmetic
class Item {
  private static _modulo: number = 1;
  private _worry_level: number;

  // Initialize modulo item
  public constructor(worry_level: number) {
    this._worry_level = worry_level;
  }

  // Add another factor to the modulo arithmetic
  public static add_modulo(modulo: number) {
    if (Item._modulo % modulo != 0) {
      Item._modulo *= modulo;
    }
  }

  // Reset modulo
  public static reset_modulo(): void {
    Item._modulo = 1;
  }

  // Add to worry level
  public add(addend: number): void {
    this._worry_level += addend;
    this.validate();
  }

  // Multiply worry level
  public multiply(factor: number): void {
    this._worry_level *= factor;
    this.validate();
  }

  // Divide worry level
  public divide(divisor: number): void {
    this._worry_level = Math.floor(this._worry_level / divisor);
    this.validate();
  }

  // Exponentiate worry level
  public pow(exponent: number): void {
    this._worry_level = Math.pow(this._worry_level, exponent);
    this.validate();
  }

  // Divisibility test
  public is_divisible_by(divisor: number): boolean {
    return this._worry_level % divisor == 0;
  }

  // Apply modulo arithmetic
  private validate(): void {
    this._worry_level %= Item._modulo;
  }
}

class Monkey {
  private _items: Item[];
  private _operation: (item: Item) => void;
  private _test_divisor: number;
  private _throw_to: number[];
  private _inspect_counter: number;
  private _worry_divisor: number;

  public constructor(monkey_str: string, worry_divisor: number = 1) {
    this._items = [];
    this._operation = (_: Item): void => {};
    this._test_divisor = 0;
    this._throw_to = Array(2);
    this._inspect_counter = 0;

    this._worry_divisor = worry_divisor;
    Item.add_modulo(this._worry_divisor);

    for (const line of monkey_str.split(/\r?\n/)) {
      // Parse items
      const match_items = line.match(/Starting items: ([0-9 ,]*)/);
      if (match_items) {
        this._items = match_items[1]!.split(', ').map((level: string): Item => {
          return new Item(Number(level));
        });
      }

      // Parse operation
      const match_op = line.match(
        /Operation: new = old ([\+|\*]) (old|[0-9]+)/
      );
      if (match_op) {
        if (match_op[1] == '+') {
          this._operation = (item: Item): void => {
            item.add(Number(match_op[2]));
          };
        } else if (match_op[1] == '*') {
          if (match_op[2] == 'old') {
            this._operation = (item: Item): void => {
              item.pow(2);
            };
          } else {
            this._operation = (item: Item): void => {
              item.multiply(Number(match_op[2]));
            };
          }
        }
      }

      // Parse divisor
      const match_divisor = line.match(/Test: divisible by ([0-9]+)/);
      if (match_divisor) {
        this._test_divisor = Number(match_divisor[1]);
        Item.add_modulo(this._test_divisor);
      }

      // Parse monkeys to throw to
      const match_true = line.match(/If true: throw to monkey ([0-9]+)/);
      if (match_true) {
        this._throw_to[1] = Number(match_true[1]);
      }
      const match_false = line.match(/If false: throw to monkey ([0-9]+)/);
      if (match_false) {
        this._throw_to[0] = Number(match_false[1]);
      }
    }
  }

  // Inspect item and pass it to another monkey
  public inspect(): [number, Item | undefined] {
    let current_item = this._items.shift();
    let monkey_id: number = -1;
    if (current_item) {
      this._operation(current_item);
      current_item.divide(this._worry_divisor);
      this._inspect_counter++;
      monkey_id =
        this._throw_to[
          Number(current_item.is_divisible_by(this._test_divisor))
        ]!;
    }

    return [monkey_id, current_item];
  }

  // Add new item to the monkeys inventory
  public push(item: Item): void {
    this._items.push(item);
  }

  // Return the amount of inspections
  public get_counter(): number {
    return this._inspect_counter;
  }
}

// ************************************************************************** //

/// First task.
export function with_worry_reduction(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');

  // Parse monkeys and disable modulo arithmetic
  Item.add_modulo(Number.POSITIVE_INFINITY);
  const monkeys: Monkey[] = contents.split(/\r?\n\r?\n/).map((str: string) => {
    return new Monkey(str, 3);
  });

  // Play 20 rounds
  for (let i: number = 1; i <= 20; i++) {
    for (let monkey of monkeys) {
      while (true) {
        let [id, item] = monkey.inspect();
        if (item) {
          monkeys[id]!.push(item);
        } else {
          break;
        }
      }
    }
  }

  // Get sorted inspection counters
  let sorted_counter = monkeys
    .map((monkey: Monkey) => {
      return monkey.get_counter();
    })
    .sort((n1, n2) => n2 - n1);

  // Calculate monkey buiness
  return sorted_counter[0]! * sorted_counter[1]!;
}

/// Second task.
export function without_worry_reduction(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');

  // Parse monkeys and enable modulo arithmetic
  Item.reset_modulo();
  const monkeys: Monkey[] = contents.split(/\r?\n\r?\n/).map((str: string) => {
    return new Monkey(str);
  });

  // Play 10000 rounds
  for (let i: number = 1; i <= 10000; i++) {
    for (let monkey of monkeys) {
      while (true) {
        let [id, item] = monkey.inspect();
        if (item) {
          monkeys[id]!.push(item);
        } else {
          break;
        }
      }
    }
  }

  // Get sorted inspection counters
  let sorted_counter = monkeys
    .map((monkey: Monkey) => {
      return monkey.get_counter();
    })
    .sort((n1, n2) => n2 - n1);

  // Calculate monkey buiness
  return sorted_counter[0]! * sorted_counter[1]!;
}
