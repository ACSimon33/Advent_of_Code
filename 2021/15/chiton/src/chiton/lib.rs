use std::fs;

mod graph;
use graph::Graph;

/// Lowest total risk with one sector.
pub fn lowest_total_risk(filename: &String) -> u32 {
  let (m, n, risks) = parse(filename);
  let cave: Graph = Graph::new(&m, &n, &risks, &1);
  return cave.dijkstra(0, m * n - 1);
}

/// Lowest total risk in the full map.
pub fn lowest_total_risk_full(filename: &String) -> u32 {
  let (m, n, risks) = parse(filename);
  let cave: Graph = Graph::new(&m, &n, &risks, &5);
  return cave.dijkstra(0, 5 * m * 5 * n - 1);
}

/// Parses the input.
fn parse(filename: &String) -> (usize, usize, Vec<u32>) {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  // Get dimensions
  let m: usize = lines.len();
  let n: usize = lines[0].chars().count();

  let mut risks: Vec<u32> = Vec::new();
  for line in lines.iter() {
    risks.extend(line.chars().map(|x| x.to_digit(10).unwrap()));
  }

  return (m, n, risks);
}

// Test example inputs against the reference solution
#[cfg(test)]
mod chiton_tests {
  use super::{lowest_total_risk, lowest_total_risk_full};
  use pretty_assertions::assert_eq;
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(lowest_total_risk(&INPUT_FILENAME.to_string()), 40);
  }

  #[test]
  fn task_2() {
    assert_eq!(lowest_total_risk_full(&INPUT_FILENAME.to_string()), 315);
  }
}
