use std::fs;

/// Count the amount of increasing measurements
pub fn increasing_measurements(filename: &String, window: usize) -> usize {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let depths: Vec<i32> = contents
    .lines()
    .map(|x| x.parse::<i32>().unwrap())
    .collect();

  return depths
    .iter()
    .zip(depths[window..].iter())
    .filter(|(a, b)| a < b)
    .count();
}
