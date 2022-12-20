import * as fs from 'fs';

// ************************************************************************** //

// 3D voxel interface
interface Voxel {
  x: number;
  y: number;
  z: number;
}

// 3D manhatten distance
function manhatten(v1: Voxel, v2: Voxel): number {
  return Math.abs(v1.x - v2.x) + Math.abs(v1.y - v2.y) + Math.abs(v1.z - v2.z);
}

// Calculate the surface by couting all sides that don't touch each other
function surface(voxels: Voxel[]) {
  let surfaces: number = 6 * voxels.length;

  for (let i: number = 0; i < voxels.length; i++) {
    const v1: Voxel = voxels[i]!;
    for (let j: number = i + 1; j < voxels.length; j++) {
      const v2: Voxel = voxels[j]!;
      if (manhatten(v1, v2) == 1) {
        surfaces -= 2;
      }
    }
  }

  return surfaces;
}

// ************************************************************************** //

/// First task.
export function surface_area(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse voxels
  const voxels: Voxel[] = lines.map((str: string): Voxel => {
    const coords = str.split(',');
    return { x: Number(coords[0]), y: Number(coords[1]), z: Number(coords[2]) };
  });

  return surface(voxels);
}

/// Second task.
export function exterior_surface_area(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Parse voxels
  const voxels: Voxel[] = lines.map((str: string): Voxel => {
    const coords = str.split(',');
    return { x: Number(coords[0]), y: Number(coords[1]), z: Number(coords[2]) };
  });

  // Determine coordinate bounds
  let x_range: number[] = [Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY];
  let y_range: number[] = [Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY];
  let z_range: number[] = [Number.POSITIVE_INFINITY, Number.NEGATIVE_INFINITY];
  for (const voxel of voxels) {
    if (voxel.x < x_range[0]!) {
      x_range[0] = voxel.x;
    }
    if (voxel.x > x_range[1]!) {
      x_range[1] = voxel.x;
    }
    if (voxel.y < y_range[0]!) {
      y_range[0] = voxel.y;
    }
    if (voxel.y > y_range[1]!) {
      y_range[1] = voxel.y;
    }
    if (voxel.z < z_range[0]!) {
      z_range[0] = voxel.z;
    }
    if (voxel.z > z_range[1]!) {
      z_range[1] = voxel.z;
    }
  }

  // Range sizes
  const x_size = x_range[1]! - x_range[0]! + 1;
  const y_size = y_range[1]! - y_range[0]! + 1;
  const z_size = z_range[1]! - z_range[0]! + 1;

  // Lambda to get a unique id for a given voxel
  let to_id = (v: Voxel): number => {
    return (
      (v.x - x_range[0]!) * y_size * z_size +
      (v.y - y_range[0]!) * z_size +
      (v.z - z_range[0]!)
    );
  };

  // Lambda to create a voxel from a given id
  let from_id = (id: number): Voxel => {
    const z_pos = id % z_size;
    const y_pos = ((id - z_pos) / z_size) % y_size;
    const x_pos = (((id - z_pos) / z_size - y_pos) / y_size) % x_size;
    return { x: x_pos, y: y_pos, z: z_pos };
  };

  // Create lava and air voxel sets
  let lava: Set<number> = new Set<number>(voxels.map((v: Voxel) => to_id(v)));
  let air: Set<number> = new Set<number>();

  // Add all sides of the surrounding cube to the air set
  for (let x: number = x_range[0]!; x <= x_range[1]!; x++) {
    for (let y: number = y_range[0]!; y <= y_range[1]!; y++) {
      const id1: number = to_id({ x: x, y: y, z: z_range[0]! });
      if (!lava.has(id1)) {
        air.add(id1);
      }
      const id2: number = to_id({ x: x, y: y, z: z_range[1]! });
      if (!lava.has(id1)) {
        air.add(id2);
      }
    }
  }
  for (let x: number = x_range[0]!; x <= x_range[1]!; x++) {
    for (let z: number = z_range[0]!; z <= z_range[1]!; z++) {
      const id1: number = to_id({ x: x, y: y_range[0]!, z: z });
      if (!lava.has(id1)) {
        air.add(id1);
      }
      const id2: number = to_id({ x: x, y: y_range[1]!, z: z });
      if (!lava.has(id1)) {
        air.add(id2);
      }
    }
  }
  for (let y: number = y_range[0]!; y <= y_range[1]!; y++) {
    for (let z: number = z_range[0]!; z <= z_range[1]!; z++) {
      const id1: number = to_id({ x: x_range[0]!, y: y, z: z });
      if (!lava.has(id1)) {
        air.add(id1);
      }
      const id2: number = to_id({ x: x_range[1]!, y: y, z: z });
      if (!lava.has(id1)) {
        air.add(id2);
      }
    }
  }

  // Add all air neighbours to the air set until no air cells are left
  let done: Set<number> = new Set<number>();
  while (done.size < air.size) {
    for (const id of air) {
      if (!done.has(id)) {
        const v: Voxel = from_id(id);

        // Add neighbours in z direction
        if (v.z > 0 && !lava.has(id - 1)) {
          air.add(id - 1);
        }
        if (v.z < z_size - 1 && !lava.has(id + 1)) {
          air.add(id + 1);
        }

        // Add neighbours in y direction
        if (v.y > 0 && !lava.has(id - z_size)) {
          air.add(id - z_size);
        }
        if (v.y < y_size - 1 && !lava.has(id + z_size)) {
          air.add(id + z_size);
        }

        // Add neighbours in x direction
        if (v.x > 0 && !lava.has(id - z_size * y_size)) {
          air.add(id - z_size * y_size);
        }
        if (v.x < x_size - 1 && !lava.has(id + z_size * y_size)) {
          air.add(id + z_size * y_size);
        }

        done.add(id);
      }
    }
  }

  // Calculate air pocket cells
  const air_pocket: Voxel[] = Array.from(Array(x_size * y_size * z_size).keys())
    .filter((id: number) => !air.has(id) && !lava.has(id))
    .map((id: number) => from_id(id));

  return surface(voxels) - surface(air_pocket);
}
