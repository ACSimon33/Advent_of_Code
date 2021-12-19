use priority_queue::PriorityQueue;
use std::cmp::Reverse;

/// Simple node
#[derive(Clone, Debug)]
pub struct Node {
  pub index: usize,
  pub risk: u32,
  pub cumulative_risk: u32,
}

impl Node {
  /// Create a new node from an index and a risk
  pub fn new(index: usize, risk: u32) -> Node {
    Node {
      index: index,
      risk: risk,
      cumulative_risk: u32::MAX,
    }
  }
}

/// Graph which holds a vector of nodes
#[derive(Clone, Debug)]
pub struct Graph {
  pub nodes: Vec<Node>,
  pub m: usize,
  pub n: usize,
}

impl Graph {
  /// Create a new graph from an initial sector
  pub fn new(m: &usize, n: &usize, risks: &Vec<u32>, dup: &usize) -> Graph {
    let mut nodes: Vec<Node> = Vec::new();
    for ki in 0..*dup {
      for i in 0..*m {
        for kj in 0..*dup {
          for j in 0..*n {
            let idx = i * n + j;
            let idx_full = (ki * m + i) * dup * n + kj * n + j;
            let mut risk = risks[idx] + (ki as u32) + (kj as u32);
            if risk > 9 {
              risk -= 9;
            }

            nodes.push(Node::new(idx_full, risk));
          }
        }
      }
    }

    Graph {
      nodes: nodes,
      m: dup * m,
      n: dup * n,
    }
  }

  /// Performs a classic dijkstra path finder using a reverse priority queue
  pub fn dijkstra(&self, start: usize, end: usize) -> u32 {
    // Clone nodes and initialize start node
    let mut nodes: Vec<Node> = self.nodes.clone();
    nodes[start].cumulative_risk = 0;

    // Create reverse priority queue
    let mut queue: PriorityQueue<usize, Reverse<u32>> = PriorityQueue::from(
      nodes
        .iter()
        .map(|n| Reverse(n.cumulative_risk))
        .enumerate()
        .collect::<Vec<(usize, Reverse<u32>)>>(),
    );

    // Dijkstra
    while queue.len() > 0 {
      let (node_idx, c_risk) = queue.pop().unwrap();
      nodes[node_idx].cumulative_risk = c_risk.0;

      for neighbour in get_stencil(&self.m, &self.n, &node_idx) {
        let neighbour_risk = queue.get_priority(&neighbour);

        if neighbour_risk.is_some() {
          let new_neighbour_risk = c_risk.0 + nodes[neighbour].risk;
          if new_neighbour_risk < neighbour_risk.unwrap().0 {
            queue.change_priority(&neighbour, Reverse(new_neighbour_risk));
          }
        }
      }
    }

    // Return risk of end node
    return nodes[end].cumulative_risk;
  }

  /// Print cave
  pub fn _print(&self) {
    println!("{} {} {}", self.nodes.len(), self.m, self.n);
    for i in 0..self.m {
      for j in 0..self.n {
        print!("{}", self.nodes[i * self.n + j].risk);
      }
      println!();
    }
  }
}

/// Returns the neighbour indices for a given index
fn get_stencil(m: &usize, n: &usize, idx: &usize) -> Vec<usize> {
  let mut stencil: Vec<usize> = Vec::new();
  if (idx + 1) % n != 1 {
    stencil.push(idx - 1);
  }
  if (idx + 1) % n != 0 {
    stencil.push(idx + 1);
  }
  if *idx >= *n {
    stencil.push(idx - n);
  }
  if *idx < (m - 1) * n {
    stencil.push(idx + n);
  }
  return stencil;
}
