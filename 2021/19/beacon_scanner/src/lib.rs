use std::cmp;
use std::fs;

mod scanner;
use regex::Regex;
use scanner::Scanner;

/// Calculate the amount of beacons.
pub fn count_beacons(filename: &String) -> usize {
  // Parse and merge scanners
  let mut scanners = parse(filename);
  merge(&mut scanners);

  return scanners[0].count();
}

/// Calculate the largest distance between any two scanners.
pub fn manhatten_distance(filename: &String) -> i32 {
  // Parse and merge scanners
  let mut scanners = parse(filename);
  merge(&mut scanners);

  let mut max_distance: i32 = 0;
  for scan1 in scanners.iter() {
    for scan2 in scanners.iter() {
      let mut distance: i32 = 0;
      distance += (scan1.position.x - scan2.position.x).abs();
      distance += (scan1.position.y - scan2.position.y).abs();
      distance += (scan1.position.z - scan2.position.z).abs();
      max_distance = cmp::max(max_distance, distance);
    }
  }

  return max_distance;
}

/// Parse the input.
pub fn parse(filename: &String) -> Vec<Scanner> {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  // Split input and parse scanners
  let seperator = Regex::new(r"(\n|\r)*--- scanner (0|[1-9][0-9]*) ---(\n|\r)*")
    .expect("Invalid regex");
  seperator
    .split(contents.as_str())
    .filter(|str| !str.is_empty())
    .map(|str| Scanner::from(str.to_string()))
    .collect()
}

/// Merge all scanners into scanner 0.
pub fn merge(scanners: &mut Vec<Scanner>) {
  let mut master = scanners[0].clone();
  master.merged = true;

  while !scanners.iter().all(|scan| scan.merged) {
    for other_scanner in scanners.iter_mut().filter(|scan| !scan.merged) {
      master.try_merge(other_scanner);
    }
  }
  scanners[0] = master;
}
