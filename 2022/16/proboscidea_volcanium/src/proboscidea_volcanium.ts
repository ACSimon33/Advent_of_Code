import * as fs from 'fs';

// ************************************************************************** //

// Valve that acts as a node in a graph
class Valve {
  private _id: string;
  private _flow_rate: number;
  private _neighbours: [Valve, number][];
  private _pressure_release: Map<string, number[]>;
  private _distances: Map<string, number>;
  private _is_open: boolean;

  // Create a valve node from the input string
  public constructor(str: string) {
    const match = str.match(/Valve ([A-Z]+) has flow rate=([0-9]*);.*/)!;
    this._id = match[1]!;
    this._flow_rate = Number(match[2]);
    this._neighbours = [];
    this._pressure_release = new Map<string, number[]>();
    this._distances = new Map<string, number>();
    this._is_open = false;
  }

  // Return the string id
  public id(): string {
    return this._id;
  }

  // Return the neighbouring valves with their corresponding distances
  public neighbours(): [Valve, number][] {
    return this._neighbours;
  }

  // Return the flow rate
  public flow_rate(): number {
    return this._flow_rate;
  }

  // Add a neighbour to this valve
  public add_neighbour(valve: Valve, time: number = 1): void {
    let found: boolean = false;
    for (let j: number = 0; j < this._neighbours.length; j++) {
      if (this._neighbours[j]![0].id() == valve.id()) {
        found = true;
        this._neighbours[j]![1] = Math.min(this._neighbours[j]![1], time);
        break;
      }
    }

    if (!found) {
      this._neighbours.push([valve, time]);
    }
  }

  // Remove a neighbour
  public remove_neighbour(id: string): void {
    for (let i: number = 0; i < this._neighbours.length; i++) {
      if (this._neighbours[i]![0].id() == id) {
        this._neighbours.splice(i, 1);
        break;
      }
    }
  }

  // Set the precalculated pressure releases for all other valves
  public set_pressure_release(pressure_release: Map<string, number[]>): void {
    this._pressure_release = new Map<string, number[]>(pressure_release);
  }

  // Return the precalculated pressure releases
  public pressure_release(): Map<string, number[]> {
    return this._pressure_release;
  }

  // Set the distances to all other valves
  public set_distances(distances: Map<string, number>): void {
    this._distances = new Map<string, number>(distances);
  }

  // Return distances to other valves
  public distances(): Map<string, number> {
    return this._distances;
  }

  // Open this valve
  public open(): void {
    this._is_open = true;
  }

  // Close this valve
  public close(): void {
    this._is_open = false;
  }

  // Check if this valve is open
  public is_open(): boolean {
    return this._is_open;
  }
}

// Perform a depth first search through the tunnels until the time's up. For
// each valve choose the agent that has the most time left. Works for an
// arbitrary amount of agents (you + elefants).
function explore_tunnels(
  valves: Map<string, Valve>,
  current: string[],
  remaining_time: number[]
): number {
  // Find agent with the most time remaining
  const max_time: number = Math.max(...remaining_time);
  const agent: number = remaining_time.indexOf(max_time);

  // Quick return if time's up
  if (max_time <= 0) {
    return 0;
  }

  let max_release: number = 0;
  const valve: Valve = valves.get(current[agent]!)!;

  // Open current valve and continue the exploration with an unopened valve
  // that is not occupied by any other agent.
  valve.open();
  for (const [id, release] of valve.pressure_release().entries()) {
    const next: Valve = valves.get(id)!;
    if (!(next.is_open() || current.includes(id))) {
      // Update agents
      let new_remaining_time = [...remaining_time];
      new_remaining_time[agent] -= valve.distances().get(id)! + 1;
      let new_current = [...current];
      new_current[agent] = id;

      // Explore
      max_release = Math.max(
        max_release,
        release[max_time - 1]! +
          explore_tunnels(valves, new_current, new_remaining_time)
      );
    }
  }
  valve.close();

  return max_release;
}

// ************************************************************************** //

/// First & second task.
export function max_pressure_release(
  filename: string,
  minutes: number,
  elefants: number
): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  const start_id: string = 'AA';

  // Parse valves
  let valves: Map<string, Valve> = new Map<string, Valve>();
  for (const line of lines) {
    const vlv = new Valve(line);
    valves.set(vlv.id(), vlv);
  }

  // Parse tunnel system
  for (const line of lines) {
    const match = line.match(/Valve ([A-Z]*) .* valves? ([A-Z ,]*)/)!;
    let vlv = valves.get(match[1]!)!;
    for (const id of match[2]!.split(', ')) {
      vlv.add_neighbour(valves.get(id)!);
    }
  }

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
  };
  while (eliminate_vertex()) {}

  // Precalculate pressure releases from each valve to each valve
  let graph: Map<string, Valve>;
  let distance: Map<string, number> = new Map<string, number>();
  for (let [id, valve] of valves.entries()) {
    // Init graph and distances for Dijkstra
    graph = new Map<string, Valve>(valves);
    for (let id2 of valves.keys()) {
      distance.set(id2, id2 == id ? 0 : Number.POSITIVE_INFINITY);
    }

    while (graph.size > 0) {
      // Get id of nearest valve
      const min_id: string = Array.from(graph.keys()).reduce(
        (acc: string, current: string) => {
          if (acc == '') {
            return current;
          }
          return distance.get(acc)! <= distance.get(current)! ? acc : current;
        },
        ''
      );

      // Update distance of neighbouring valves
      for (const [neighbour, dist] of graph.get(min_id)!.neighbours()) {
        distance.set(
          neighbour.id(),
          Math.min(distance.get(neighbour.id())!, distance.get(min_id)! + dist)
        );
      }

      // Remove valve
      graph.delete(min_id);
    }

    // Calculate pressure releases for each valve and time step from the
    // perspective of the current valve.
    let pressure_release: Map<string, number[]> = new Map<string, number[]>();
    for (const [id2, dist] of distance.entries()) {
      let release_timeline: number[] = new Array<number>(minutes);
      for (let i: number = 0; i < minutes; i++) {
        release_timeline[i] =
          Math.max(0, i - dist) * valves.get(id2)!.flow_rate();
      }
      pressure_release.set(id2, release_timeline);
    }
    valve.set_distances(distance);
    valve.set_pressure_release(pressure_release);
  }

  // Initialize agents
  let remaining_time: number[] = new Array<number>(elefants + 1);
  remaining_time.fill(minutes - 4 * elefants);
  let start: string[] = new Array<string>(elefants + 1);
  start.fill(start_id);

  // Explore tunnel system until 30 minutes are reached
  return explore_tunnels(valves, start, remaining_time);
}
