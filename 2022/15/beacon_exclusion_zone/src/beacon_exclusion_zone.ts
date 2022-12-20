import * as fs from 'fs';

// ************************************************************************** //

// Range
interface Range {
  start: number;
  end: number;
}

// Coverage of an interval consisting of a collection of ranges
class Coverage {
  private _ranges: Range[];

  // Create an empty coverage object
  public constructor() {
    this._ranges = [];
  }

  // Add a range to the coverage
  public add(range: Range): void {
    if (range.end < range.start) {
      return;
    }

    this._ranges.push(range);
  }

  // Calculate size of the covered range
  public size(): number {
    let covered_points: number = 0;
    let start: number = this.find_start();
    let end: number;

    while (Number.isFinite(start)) {
      end = this.find_uncovered({
        start: start,
        end: Number.POSITIVE_INFINITY
      })!;
      covered_points += end - start;
      start = this.find_start(end);
    }

    return covered_points;
  }

  // Find the first uncovered index in the given range
  public find_uncovered(interval: Range): number | undefined {
    let current_idx: number = interval.start;
    while (current_idx <= interval.end) {
      let old_idx = current_idx;
      for (const range of this._ranges) {
        if (current_idx >= range.start && current_idx <= range.end) {
          current_idx = range.end + 1;
        }
      }

      if (current_idx == old_idx) {
        return current_idx;
      }
    }

    return undefined;
  }

  // Delete all ranges in the coverage object
  public reset(): void {
    this._ranges = [];
  }

  // Find starting point of a range above a certain point
  private find_start(lb: number = Number.NEGATIVE_INFINITY): number {
    return this._ranges.reduce((acc: number, range: Range): number => {
      return range.start >= lb && range.start < acc ? range.start : acc;
    }, Number.POSITIVE_INFINITY);
  }
}

// Sensor at a given point with the beacon it's detecting
class Sensor {
  private _coords: number[];
  private _beacon: number[];

  // Create a sensor from a string input
  public constructor(str: string) {
    const matches = str.match(
      /Sensor at x=(-?[0-9]+), y=(-?[0-9]+): /.source +
        /closest beacon is at x=(-?[0-9]+), y=(-?[0-9]+)/.source
    )!;

    this._coords = [Number(matches[1]), Number(matches[2])];
    this._beacon = [Number(matches[3]), Number(matches[4])];
  }

  // Return the range of a given scanline that is covered by this sensor
  public scan_line(y: number): [number | undefined, Range] {
    const distance_x: number = Math.abs(this._beacon[0]! - this._coords[0]!);
    const distance_y: number = Math.abs(this._beacon[1]! - this._coords[1]!);
    const manhatten: number = distance_x + distance_y;
    const d: number = manhatten - Math.abs(this._coords[1]! - y);

    return [
      this._beacon[1] == y ? this._beacon[0] : undefined,
      { start: this._coords[0]! - d, end: this._coords[0]! + d }
    ];
  }
}

// ************************************************************************** //

/// First task.
export function invalid_positions(filename: string, y: number): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  const sensors: Sensor[] = lines.map((line: string) => new Sensor(line));
  let beacons: Set<number> = new Set<number>();

  // Create coverage for given scan line
  let cov: Coverage = new Coverage();
  sensors.forEach((sensor: Sensor): void => {
    let scan = sensor.scan_line(y);
    if (scan[0]) {
      beacons.add(scan[0]);
    }
    cov.add(scan[1]);
  });

  return cov.size() - beacons.size;
}

/// Second task.
export function tuning_frequency(filename: string, size: number): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse sensors
  const sensors: Sensor[] = lines.map((line: string) => new Sensor(line));

  let cov: Coverage = new Coverage();
  let x: number = -1;
  let y: number = -1;
  for (y = 0; y <= size; y++) {
    // Create coverage for current scan line
    cov.reset();
    sensors.forEach((sensor: Sensor): void => {
      cov.add(sensor.scan_line(y)[1]);
    });

    let idx = cov.find_uncovered({ start: 0, end: size });
    if (idx) {
      x = idx;
      break;
    }
  }

  return 4000000 * x + y;
}
