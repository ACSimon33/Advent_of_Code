import * as fs from 'fs';

// ************************************************************************** //

// Abstract superclass for arithmetic operations
abstract class Op {
  protected _id: string;
  protected _parent_id: string | null;

  // Create an operation with a given id
  public constructor(id: string) {
    this._id = id;
    this._parent_id = null;
  }

  // Return the id of the operation
  public id(): string {
    return this._id;
  }

  // Set the parent operation's id
  public set_parent(parent_id: string): void {
    this._parent_id = parent_id;
  }

  // Abstract method to connect this operation with its the children
  public abstract connect(ops: Map<string, Op>): void;

  // Abstract method to evaluate the operation
  public abstract evaluate(ops: Map<string, Op>): number;

  // Abstract method to evaluate the inverted operation
  public abstract invert(ops: Map<string, Op>, child?: string): number;
}

// Operation class that holds a constant value
class Value extends Op {
  private _value: number;

  // Parse a constant value
  constructor(str: string) {
    const match = str.match(/([a-z]*): ([0-9]*)/)!;
    super(match[1]!);

    this._value = Number(match[2]!);
  }

  // Noop (constant value has no children)
  public connect(_: Map<string, Op>): void {}

  // Evaluate: Return the constant value
  public evaluate(_: Map<string, Op>): number {
    return this._value;
  }

  // Invert: Call the inversion of the parent
  public invert(ops: Map<string, Op>, _?: string): number {
    return ops.get(this._parent_id!)!.invert(ops, this._id);
  }
}

// Operation class that defines an addition
class Addition extends Op {
  private _augend: string;
  private _addend: string;

  // Parse an addition expression
  constructor(str: string) {
    const match = str.match(/([a-z]*): ([a-z]*) \+ ([a-z]*)/)!;
    super(match[1]!);

    this._augend = match[2]!;
    this._addend = match[3]!;
  }

  // Connect the addition to the augent and addend operations
  public connect(ops: Map<string, Op>): void {
    ops.get(this._augend)!.set_parent(this._id);
    ops.get(this._addend)!.set_parent(this._id);
  }

  // Evaluate augent and addend operations and add up the results
  public evaluate(ops: Map<string, Op>): number {
    const augent = ops.get(this._augend)!;
    const addend = ops.get(this._addend)!;
    return augent.evaluate(ops) + addend.evaluate(ops);
  }

  // Invert the addition and return the child's result
  public invert(ops: Map<string, Op>, child?: string): number {
    const parent = ops.get(this._parent_id!)!;
    if (child! == this._augend) {
      const addend = ops.get(this._addend)!;
      return parent.invert(ops, this._id) - addend.evaluate(ops);
    } else if (child! == this._addend) {
      const augent = ops.get(this._augend)!;
      return parent.invert(ops, this._id) - augent.evaluate(ops);
    }

    return NaN;
  }
}

// Operation class that defines a subtraction
class Subtraction extends Op {
  private _minuend: string;
  private _subtrahend: string;

  // Parse a subtraction expression
  constructor(str: string) {
    const match = str.match(/([a-z]*): ([a-z]*) \- ([a-z]*)/)!;
    super(match[1]!);

    this._minuend = match[2]!;
    this._subtrahend = match[3]!;
  }

  // Connect the addition to the minuend and subtrahend operations
  public connect(ops: Map<string, Op>): void {
    ops.get(this._minuend)!.set_parent(this._id);
    ops.get(this._subtrahend)!.set_parent(this._id);
  }

  // Evaluate minuend and subtrahend operations and subtract the results
  public evaluate(ops: Map<string, Op>): number {
    const minuend = ops.get(this._minuend)!;
    const subtrahend = ops.get(this._subtrahend)!;
    return minuend.evaluate(ops) - subtrahend.evaluate(ops);
  }

  // Invert the subtraction and return the child's result
  public invert(ops: Map<string, Op>, child?: string): number {
    const parent = ops.get(this._parent_id!)!;
    if (child! == this._minuend) {
      const subtrahend = ops.get(this._subtrahend)!;
      return parent.invert(ops, this._id) + subtrahend.evaluate(ops);
    } else if (child! == this._subtrahend) {
      const minuend = ops.get(this._minuend)!;
      return minuend.evaluate(ops) - parent.invert(ops, this._id);
    }

    return NaN;
  }
}

// Operation class that defines a multiplication
class Multiplication extends Op {
  private _multiplier: string;
  private _multiplicand: string;

  // Parse a multiplication expression
  constructor(str: string) {
    const match = str.match(/([a-z]*): ([a-z]*) \* ([a-z]*)/)!;
    super(match[1]!);

    this._multiplier = match[2]!;
    this._multiplicand = match[3]!;
  }

  // Connect the addition to the multiplier and multiplicand operations
  public connect(ops: Map<string, Op>): void {
    ops.get(this._multiplier)!.set_parent(this._id);
    ops.get(this._multiplicand)!.set_parent(this._id);
  }

  // Evaluate multiplier and multiplicand operations and multiply the results
  public evaluate(ops: Map<string, Op>): number {
    const multiplier = ops.get(this._multiplier)!;
    const multiplicand = ops.get(this._multiplicand)!;
    return multiplier.evaluate(ops) * multiplicand.evaluate(ops);
  }

  // Invert the multiplication and return the child's result
  public invert(ops: Map<string, Op>, child?: string): number {
    const parent = ops.get(this._parent_id!)!;
    if (child! == this._multiplier) {
      const multiplicand = ops.get(this._multiplicand)!;
      return parent.invert(ops, this._id) / multiplicand.evaluate(ops);
    } else if (child! == this._multiplicand) {
      const multiplier = ops.get(this._multiplier)!;
      return parent.invert(ops, this._id) / multiplier.evaluate(ops);
    }

    return NaN;
  }
}

// Operation class that defines a division
class Division extends Op {
  private _dividend: string;
  private _divisor: string;

  // Parse a division expression
  constructor(str: string) {
    const match = str.match(/([a-z]*): ([a-z]*) \/ ([a-z]*)/)!;
    super(match[1]!);

    this._dividend = match[2]!;
    this._divisor = match[3]!;
  }

  // Connect the addition to the dividend and divisor operations
  public connect(ops: Map<string, Op>): void {
    ops.get(this._dividend)!.set_parent(this._id);
    ops.get(this._divisor)!.set_parent(this._id);
  }

  // Evaluate dividend and divisor operations and divide the results
  public evaluate(ops: Map<string, Op>): number {
    const dividend = ops.get(this._dividend)!;
    const divisor = ops.get(this._divisor)!;
    return dividend.evaluate(ops) / divisor.evaluate(ops);
  }

  // Invert the division and return the child's result
  public invert(ops: Map<string, Op>, child?: string): number {
    const parent = ops.get(this._parent_id!)!;
    if (child! == this._dividend) {
      const divisor = ops.get(this._divisor)!;
      return parent.invert(ops, this._id) * divisor.evaluate(ops);
    } else if (child! == this._divisor) {
      const dividend = ops.get(this._dividend)!;
      return dividend.evaluate(ops) / parent.invert(ops, this._id);
    }

    return NaN;
  }
}

// Operation class that defines an equal comparison
class Equal extends Op {
  private _lhs: string;
  private _rhs: string;

  // Parse a comparison expression
  constructor(str: string) {
    const match = str.match(/([a-z]*): ([a-z]*) \+ ([a-z]*)/)!;
    super(match[1]!);

    this._lhs = match[2]!;
    this._rhs = match[3]!;
  }

  // Connect the comparison to the left- and right-hand-side operations
  public connect(ops: Map<string, Op>): void {
    ops.get(this._lhs)!.set_parent(this._id);
    ops.get(this._rhs)!.set_parent(this._id);
  }

  // Evaluate left- and right-hand-side operations and compare the results
  public evaluate(ops: Map<string, Op>): number {
    const lhs = ops.get(this._lhs)!;
    const rhs = ops.get(this._rhs)!;
    return Number(lhs.evaluate(ops) == rhs.evaluate(ops));
  }

  // Return the evaluation result of the other side
  public invert(ops: Map<string, Op>, child?: string): number {
    if (child! == this._lhs) {
      return ops.get(this._rhs)!.evaluate(ops);
    } else if (child! == this._rhs) {
      return ops.get(this._lhs)!.evaluate(ops);
    }

    return NaN;
  }
}
// ************************************************************************** //

/// First task.
export function evaluate(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse the operations
  let ops: Map<string, Op> = new Map<string, Op>();
  for (const line of lines) {
    let op: Op;
    if (line.includes('+')) {
      op = new Addition(line);
    } else if (line.includes('-')) {
      op = new Subtraction(line);
    } else if (line.includes('*')) {
      op = new Multiplication(line);
    } else if (line.includes('/')) {
      op = new Division(line);
    } else {
      op = new Value(line);
    }

    ops.set(op.id(), op);
  }

  // Evaluate from the root operation
  return ops.get('root')!.evaluate(ops);
}

/// Second task.
export function inverse_evaluate(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse the operations
  let ops: Map<string, Op> = new Map<string, Op>();
  for (const line of lines) {
    let op: Op;
    if (line.includes('root')) {
      op = new Equal(line);
    } else if (line.includes('+')) {
      op = new Addition(line);
    } else if (line.includes('-')) {
      op = new Subtraction(line);
    } else if (line.includes('*')) {
      op = new Multiplication(line);
    } else if (line.includes('/')) {
      op = new Division(line);
    } else {
      op = new Value(line);
    }

    ops.set(op.id(), op);
  }

  // Connect the children operations with their parents
  for (const op of ops.values()) {
    op.connect(ops);
  }

  // Solve for the 'humn' variable by inverting the operations
  return ops.get('humn')!.invert(ops);
}
