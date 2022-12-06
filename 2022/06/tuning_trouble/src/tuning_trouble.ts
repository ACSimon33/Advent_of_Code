import * as fs from 'fs';

// ************************************************************************** //

// Interface for a generic queue
interface QueueInterface<T> {
  push(elememt: T): void;
  pop(): T | undefined;
}

// Class that implements a simple stack
class Marker<T> implements QueueInterface<T> {
  private _queue: T[];
  private _capacity: number;

  // Init an emtpy queue
  public constructor(capacity: number = Number.POSITIVE_INFINITY) {
    this._queue = [];
    this._capacity = capacity;
  }

  // Push to the queue (pop elements if capacity is reached)
  public push(elememt: T): void {
    if (this.is_full()) {
      this.pop();
    }
    this._queue.push(elememt);
  }

  // Pop the top element from the queue
  public pop(): T | undefined {
    return this._queue.shift();
  }

  // Queck if marker is at full capacity
  public is_full(): boolean {
    return this._queue.length == this._capacity;
  }

  // Queck if marker contains duplicate elements
  public has_duplicates(): boolean {
    for (let i = 0; i < this._queue.length; i++) {
      for (let j = i + 1; j < this._queue.length; j++) {
        if (this._queue[i] == this._queue[j]) {
          return true;
        }
      }
    }

    return false;
  }
}

// ************************************************************************** //

/// First & second task.
export function find_start_marker(
  filename: string,
  marker_length: number
): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const chars = contents.split('');

  // Initialize marker
  const marker: Marker<string> = new Marker<string>(marker_length);

  let position: number = 0;
  for (const char of chars) {
    position++;
    marker.push(char);
    if (marker.is_full() && !marker.has_duplicates()) {
      break;
    }
  }

  return position;
}
