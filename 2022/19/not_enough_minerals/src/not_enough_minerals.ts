import * as fs from 'fs';

// ************************************************************************** //

// Materials
enum Material {
  ORE = 0,
  CLAY = 1,
  OBSIDIAN = 2,
  GEODE = 3,
  TYPES = 4
}

// Typedef for material costs
type MaterialCost = number[];

// Factory that holds the blueprint for the robots
class Factory {
  private _id: number;
  private _costs: MaterialCost[];

  // Parse the blueprint
  public constructor(str: string) {
    const match = str.match(
      /Blueprint ([0-9]*): Each ore robot costs ([0-9]*) ore. /.source +
        /Each clay robot costs ([0-9]*) ore. /.source +
        /Each obsidian robot costs ([0-9]*) ore and ([0-9]*) clay. /.source +
        /Each geode robot costs ([0-9]*) ore and ([0-9]*) obsidian./.source
    )!;

    this._id = Number(match[1]);
    this._costs = new Array<MaterialCost>(Material.TYPES);
    this._costs[Material.ORE] = [Number(match[2]), 0, 0];
    this._costs[Material.CLAY] = [Number(match[3]), 0, 0];
    this._costs[Material.OBSIDIAN] = [Number(match[4]), Number(match[5]), 0];
    this._costs[Material.GEODE] = [Number(match[6]), 0, Number(match[7])];
  }

  // Return the id of the blueprint
  public id(): number {
    return this._id;
  }

  // Return the cost of the robot that mines the given material
  public robot_cost(material: Material): MaterialCost {
    return this._costs[material];
  }

  public max_cost(): MaterialCost {
    return this._costs.reduce((acc: MaterialCost, current: MaterialCost) => {
      return acc.map((cost: number, m: Material) => Math.max(cost, current[m]));
    }, [0, 0, 0]);
  }
}

// Invetory that holds information about material and robot amounts
class Inventory {
  private _materials: number[];
  private _robots: number[];
  private _max_costs: MaterialCost;

  // Create an inventory with a single ore robot
  public constructor(max_costs: MaterialCost) {
    this._materials = new Array<number>(Material.TYPES);
    this._materials[Material.ORE] = 0;
    this._materials[Material.CLAY] = 0;
    this._materials[Material.OBSIDIAN] = 0;
    this._materials[Material.GEODE] = 0;

    this._robots = new Array<number>(Material.TYPES);
    this._robots[Material.ORE] = 1;
    this._robots[Material.CLAY] = 0;
    this._robots[Material.OBSIDIAN] = 0;
    this._robots[Material.GEODE] = 0;

    this._max_costs = max_costs;
  }

  // Mine for a certain amount of time
  public mine(time: number): void {
    for (let m: Material = Material.ORE; m < Material.TYPES; m++) {
      this._materials[m] += this._robots[m] * time;
    }
  }

  // Undo the mining
  public unmine(time: number): void {
    for (let m: Material = Material.ORE; m < Material.TYPES; m++) {
      this._materials[m] -= this._robots[m] * time;
    }
  }

  // Caluclate the time it needs until we can build a certain robot
  public time_to_build(robot_type: Material, cost: MaterialCost): number {
    if (robot_type != Material.GEODE) {
      if (this._robots[robot_type] >= this._max_costs[robot_type]) {
        return Number.POSITIVE_INFINITY;
      }
    }

    return cost.reduce((diff, amount: number, m: Material) => {
      if (amount - this._materials[m] > 0) {
        if (this._robots[m] == 0) {
          return Number.POSITIVE_INFINITY;
        } else {
          return Math.max(
            diff,
            1 + Math.ceil((amount - this._materials[m]) / this._robots[m])
          );
        }
      }
      return diff;
    }, 1);
  }

  // Build a certain robot
  public build(robot_type: Material, cost: MaterialCost): void {
    for (let m: Material = Material.ORE; m < Material.TYPES - 1; m++) {
      this._materials[m] -= cost[m];
    }
    this._robots[robot_type] += 1;
  }

  // Destroy a certain robot and harvest it's materials
  public restore(robot_type: Material, cost: MaterialCost): void {
    for (let m: Material = Material.ORE; m < Material.TYPES - 1; m++) {
      this._materials[m] += cost[m];
    }
    this._robots[robot_type] -= 1;
  }

  // Return projected number of geodes
  public geodes(t: number = 0): number {
    return this._materials[Material.GEODE] + t * this._robots[Material.GEODE];
  }

  // Return the maximal possible amount of geodes
  public max_geodes(t: number = 0): number {
    return this.geodes(t) + ((t - 1) * t) / 2;
  }

  // Create a hash value for the current inventory
  public hash(t: number = 0): number {
    let inventory_hash: number = t;
    for (let m: Material = Material.ORE; m < Material.TYPES - 1; m++) {
      inventory_hash += Math.pow(2, 5 + 5 * m) * this._robots[m];
    }
    for (let m: Material = Material.ORE; m < Material.TYPES - 1; m++) {
      inventory_hash += Math.pow(2, 25 + 8 * m) * this._materials[m];
    }
    return inventory_hash;
  }
}

// Mine for geodes for a certain amount of time. Return the maximum amount.
function mine_geodes(
  factory: Factory,
  time: number,
  inventory: Inventory = new Inventory(factory.max_cost()),
  current_geodes: number = 0
): number {
  let geodes: number = 0;

  // Quick return if time's up
  if (time == 1) {
    return inventory.max_geodes(time);
  }

  // Quick return if the current maximum is higher than the projected maximum
  if (current_geodes >= inventory.max_geodes(time)) {
    return current_geodes;
  }

  // Build robots if there is time
  for (let m: Material = Material.GEODE; m >= Material.ORE; m--) {
    let t: number = inventory.time_to_build(m, factory.robot_cost(m));
    if (t < time) {
      inventory.mine(t);
      inventory.build(m, factory.robot_cost(m));
      geodes = Math.max(
        geodes,
        mine_geodes(factory, time - t, inventory, geodes)
      );
      inventory.restore(m, factory.robot_cost(m));
      inventory.unmine(t);
    } else {
      geodes = Math.max(geodes, inventory.geodes(time));
    }
  }

  return geodes;
}

// ************************************************************************** //

/// First task.
export async function blueprint_quality(filename: string): Promise<number> {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse blueprints / factories
  const factories: Factory[] = lines.map((line: string) => new Factory(line));

  // Create tasks for each blueprint
  let promises: Promise<number>[] = [];
  for (const factory of factories) {
    promises.push(
      new Promise<number>((resolve) => {
        resolve(mine_geodes(factory, 24) * factory.id());
      })
    );
  }

  // Combine promises
  return Promise.all(promises).then((values) => {
    return values.reduce((acc: number, val: number) => acc + val, 0);
  });
}

/// Second task.
export async function geodes_product(filename: string): Promise<number> {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse blueprints / factories
  const factories: Factory[] = lines.map((line: string) => new Factory(line));

  // Create tasks for each blueprint
  let promises: Promise<number>[] = [];
  for (let i: number = 0; i < Math.min(factories.length, 3); i++) {
    promises.push(
      new Promise<number>((resolve) => {
        resolve(mine_geodes(factories[i], 32));
      })
    );
  }

  // Combine promises
  return Promise.all(promises).then((values) => {
    return values.reduce((acc: number, val: number) => acc * val, 1);
  });
}
