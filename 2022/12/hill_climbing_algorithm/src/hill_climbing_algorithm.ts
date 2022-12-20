import * as fs from 'fs';
import PriorityQueue = require('priority-queue-typescript');

// ************************************************************************** //

// Node interface
interface Node {
  id: number;
  elevation: number;
  distance: number;
  neighbours: Node[];
}

// Calculate the distance between two nodes or from one node to all others
function distance(nodes: Node[], start: number, end?: number): number {
  // Create priority queue and add starting node
  let queue = new PriorityQueue.default<Node>(nodes.length, (n1: Node, n2: Node) => {
    return n1.distance - n2.distance;
  });
  queue.add(nodes[start]);

  // Create a set to store the processed node ids
  let done: Set<number> = new Set<number>();

  // Iterate until we find the optimal solution or the queue is empty
  do {
    let current: Node = queue.poll()!;

    // If the end nodes is found, return the current path length
    if (end !== undefined && current.id == nodes[end].id) {
      return current.distance;
    }

    // Add node to processed nodes and add its neighbours to the queue
    done.add(current.id);
    for (let node of current.neighbours) {
      if (done.has(node.id)) {
        continue;
      }

      // Add node to the queue and/or update the priority
      if (!queue.contains(node)) {
        node.distance = current.distance + 1;
        queue.add(node);
      } else {
        node.distance = Math.min(node.distance, current.distance + 1);
      }
    }
  } while (!queue.empty());

  // No path found (if an end node was given)
  return -1;
}

// Parse input height map to a graph
function parse_nodes(lines: string[]): [Node[], number, number] {
  const height: number = lines.length;
  const width: number = lines[0].length;
  const n: number = width * height;

  let nodes: Node[] = Array.from(Array(n).keys()).map((idx: number): Node => {
    return { id: idx, elevation: 0, distance: 0, neighbours: [] };
  });
  let start: number = -1;
  let end: number = -1;

  // Function to calculate the node id from its 2D index
  let index = (i: number, j: number): number => {
    return i * width + j;
  };

  for (let i: number = 0; i < height; i++) {
    for (let j: number = 0; j < width; j++) {
      const idx = index(i, j);

      // Start
      if (lines[i].charAt(j) == 'S') {
        lines[i] = lines[i].replace('S', 'a');
        start = idx;
      }

      // End
      if (lines[i].charAt(j) == 'E') {
        lines[i] = lines[i].replace('E', 'z');
        end = idx;
      }

      // Elevation
      nodes[idx].elevation = lines[i].charCodeAt(j);

      // Left neighbour
      if (j > 0) {
        if (nodes[idx].elevation - lines[i].charCodeAt(j - 1) <= 1) {
          nodes[idx].neighbours.push(nodes[index(i, j - 1)]);
        }
      }

      // Right neighbour
      if (j < width - 1) {
        if (nodes[idx].elevation - lines[i].charCodeAt(j + 1) <= 1) {
          nodes[idx].neighbours.push(nodes[index(i, j + 1)]);
        }
      }

      // Top neighbour
      if (i > 0) {
        if (nodes[idx].elevation - lines[i - 1].charCodeAt(j) <= 1) {
          nodes[idx].neighbours.push(nodes[index(i - 1, j)]);
        }
      }

      // Bottom neighbour
      if (i < height - 1) {
        if (nodes[idx].elevation - lines[i + 1].charCodeAt(j) <= 1) {
          nodes[idx].neighbours.push(nodes[index(i + 1, j)]);
        }
      }
    }
  }

  return [nodes, start, end];
}

// ************************************************************************** //

/// First task.
export function shortest_path(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  let lines = contents.split(/\r?\n/);

  // Calculate distance between end and start node (in reverse)
  let [nodes, start, end] = parse_nodes(lines);
  return distance(nodes, end, start);
}

/// Second task.
export function shortest_path_overall(filename: string): number {
  const contents: string = fs.readFileSync(filename, 'utf8');
  const lines = contents.split(/\r?\n/);

  // Calculate distance between end node and all other nodes
  let [nodes, _, end] = parse_nodes(lines);
  distance(nodes, end);

  // Calculate shortest distance from the bottom to the top
  return nodes
    .filter((node: Node): boolean => {
      return node.elevation == 'a'.charCodeAt(0) && node.distance > 0;
    })
    .reduce((prev: number, node: Node): number => {
      return Math.min(prev, node.distance);
    }, Number.MAX_SAFE_INTEGER);
}
