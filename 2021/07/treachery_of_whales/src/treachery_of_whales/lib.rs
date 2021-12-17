use std::fs;

/// Calculate the optimal position and fuel consumption if the submarines
/// have constant fuel consumption.
pub fn crab_formation_1(filename: &String) -> (i32, i32) {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let mut crabs: Vec<i32> = contents.split(",")
    .map(|x| x.parse().unwrap()).collect();

  crabs.sort();
  let mid1 = crabs.len() / 2;
  let mid2 = crabs.len() / 2 - 1;
  let mut pos = crabs[mid1];

  // Correct median for even values
  if crabs.len() % 2 == 0 {
    pos = (crabs[mid1] + crabs[mid2]) / 2;
  }

  return (pos, calculate_fuel_consumption_1(&crabs, &pos));
}

/// Constant fuel consumption.
fn calculate_fuel_consumption_1(crabs: &Vec<i32>, position: &i32) -> i32 {
  crabs.iter().map(|c| (c-position).abs()).sum()
}

/// Calculate the optimal position and fuel consumption if the submarines
/// have linear fuel consumption.
pub fn crab_formation_2(filename: &String) -> (i32, i32) {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let crabs: Vec<i32> = contents.split(",")
    .map(|x| x.parse().unwrap()).collect();

  let pos: f32 = (crabs.iter().sum::<i32>() as f32) / (crabs.len() as f32);
  let fuel_left = calculate_fuel_consumption_2(&crabs, &(pos.floor() as i32));
  let fuel_right = calculate_fuel_consumption_2(&crabs, &(pos.ceil() as i32));

  if fuel_left < fuel_right {
    return (pos.floor() as i32, fuel_left);
  } else {
    return (pos.ceil() as i32, fuel_right);
  }
}

/// Linear fuel consumption.
fn calculate_fuel_consumption_2(crabs: &Vec<i32>, position: &i32) -> i32 {
  crabs.iter().map(|c| gauss_sum((c-position).abs())).sum()
}

/// Gaussian sum
fn gauss_sum(i: i32) -> i32 {
  i * (i+1) / 2
}

// Test example inputs against the reference solution
#[cfg(test)]
mod treachery_of_whales_tests {
  use super::{crab_formation_1, crab_formation_2};
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    assert_eq!(crab_formation_1(&INPUT_FILENAME.to_string()), (2, 37));
  }

  #[test]
  fn task_2() {
    assert_eq!(crab_formation_2(&INPUT_FILENAME.to_string()), (5, 168));
  }
}

