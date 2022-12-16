import exp from 'constants';
import * as fs from 'fs';

// ************************************************************************** //

class Valve {
  private _id: string;
  private _flow_rate: number;
  private _neighbours: [Valve, number][];
  private _is_open: boolean;
  private _visited: boolean;

  public constructor(str: string) {
    const match = str.match(/Valve ([A-Z]+) has flow rate=([0-9]*);.*/)!;
    this._id = match[1];
    this._flow_rate = Number(match[2]);
    this._neighbours = [];
    this._is_open = (this._flow_rate == 0);
    this._visited = false;
  }

  public id(): string {
    return this._id;
  }

  public neighbours(): [Valve, number][] {
    return this._neighbours;
  }

  public flow_rate(): number {
    return this._flow_rate;
  }

  public add_neighbour(valve: Valve, time: number = 1): void {
    let found: boolean = false;
    for (let j: number = 0; j < this._neighbours.length; j++) {
      if (this._neighbours[j][0].id() == valve.id()) {
        found = true;
        this._neighbours[j][1] = Math.min(this._neighbours[j][1], time);
        break;
      }
    }

    if (!found) {
      // console.log("Add neighbour", valve.id(), "to valve", this._id)
      this._neighbours.push([valve, time]);
    }
  }

  public remove_neighbour(id: string): void {
    for (let i: number = 0; i < this._neighbours.length; i++) {
      if (this._neighbours[i][0].id() == id) {
        // console.log("Remove neighbour", id, "from valve", this._id)
        this._neighbours.splice(i, 1);
        break;
      }
    }
  }

  public distance_to_closed_valve(prev: string = this._id): number {
    if (!this._is_open) {
      return 0;
    }

    if (this._visited) {
      return Number.POSITIVE_INFINITY;
    }

    this._visited = true;
    const distance = this._neighbours.reduce((acc: number, [valve, distance]: [Valve, number]): number => {
      if (prev == valve.id()) {
        return acc;
      }
      return Math.min(acc, distance + valve.distance_to_closed_valve(this._id))
    }, Number.POSITIVE_INFINITY);
    this._visited = false;

    return distance;
  }

  public open(): void {
    this._is_open = true;
  }

  public close(): void {
    this._is_open = false;
  }

  public is_open(): boolean {
    return this._is_open;
  }
}

function explore_tunnels(
  current: Valve,
  current_flow: number,
  max_flow: number,
  time: number
) {
  // Quick return is time's up
  if (time <= 0) {
    return 0;
  }

  // Prune branch
  if (current_flow == max_flow) {
    console.log(time)
    return time * max_flow;
  }

  // We spend at least one minute here (walking or opening the valve)
  if (time <= 1) {
    return current_flow;
  }

  // Open the current valve and explore
  let release_1: number = 0;
  if (!current.is_open()) {
    // Open valve
    release_1 += current_flow
    current.open();
    current_flow += current.flow_rate();
    time--;

    release_1 += current
      .neighbours()
      .reduce((acc: number, [neighbour, distance]: [Valve, number]) => {
        // if (neighbour.distance_to_closed_valve(current.id()) == Number.POSITIVE_INFINITY) {
        //   return acc;
        // }

        const steps: number = Math.min(distance, time);
        return Math.max(
          acc,
          current_flow * steps + explore_tunnels(
            neighbour,
            current_flow,
            max_flow,
            time - steps
          )
        );
      }, 0);

    // Close valve
    current.close();
    current_flow -= current.flow_rate();
    time++;
  }

  // Explore tunnels without opening the current valve
  let release_2: number = current
    .neighbours()
    .reduce((acc: number, [neighbour, distance]: [Valve, number]) => {
      // if (neighbour.distance_to_closed_valve(current.id()) == Number.POSITIVE_INFINITY) {
      //   return acc;
      // }

      const steps: number = Math.min(distance, time);
      return Math.max(
        acc,
        current_flow * steps + explore_tunnels(
          neighbour,
          current_flow,
          max_flow,
          time - steps
        )
      );
    }, 0);

  return Math.max(release_1, release_2);
}

// ************************************************************************** //

/// First task.
export function solution_1(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  const start_id: string = 'AA';

  // Parse valves
  let valves: Map<string, Valve> = new Map<string, Valve>();
  for (const line of lines) {
    const vlv = new Valve(line);
    valves.set(vlv.id(), vlv);
  }

  //console.log(valves)

  // Parse tunnel system
  for (const line of lines) {
    const match = line.match(/Valve ([A-Z]*) .* valves? ([A-Z ,]*)/)!;
    let vlv = valves.get(match[1])!;
    for (const id of match[2].split(', ')) {
      vlv.add_neighbour(valves.get(id)!);
    }
  }

  //console.log(valves)

  // Remove valves with zero flow rate
  const eliminate_vertex = (): boolean => {
    for (const [id, valve] of valves.entries()) {
      if (id != start_id && valve.flow_rate() == 0) {
        for (const [neighbour1, time1] of valve.neighbours()) {
          for (const [neighbour2, time2] of valve.neighbours()) {
            if (neighbour1.id() != neighbour2.id()) {
              neighbour1.remove_neighbour(id);
              neighbour1.add_neighbour(neighbour2, time1 + time2);
              neighbour2.remove_neighbour(id);
              neighbour2.add_neighbour(neighbour1, time1 + time2);
            }
          }
        }

        valves.delete(id);
        return true;
      }
    }

    return false;
  }

  while (eliminate_vertex()) {}

  //console.log(valves)

  const max_flow = Array.from(valves.values()).reduce((acc: number, valve: Valve) => {
    return acc + valve.flow_rate();
  }, 0);

  // Explore tunnel system until 30 minutes are reached
  return explore_tunnels(valves.get('AA')!, 0, max_flow, 25);
}

/// Second task.
export function solution_2(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  return 43;
}
