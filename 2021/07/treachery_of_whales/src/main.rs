use std::fs;
use std::env;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename: &String = &args[1];

  let (pos_1, fuel_1) = crab_formation_1(&filename);
  println!("1. Position: {}", pos_1);
  println!("1. Fuel Consumption: {}", fuel_1);

  let (pos_2, fuel_2) = crab_formation_2(&filename);
  println!("2. Position: {}", pos_2);
  println!("2. Fuel Consumption: {}", fuel_2);
}

fn crab_formation_1(filename: &String) -> (i32, i32) {
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

  return (pos, calclate_fuel_consumption_1(&crabs, &pos));
}

fn calclate_fuel_consumption_1(crabs: &Vec<i32>, position: &i32) -> i32 {
  crabs.iter().map(|c| (c-position).abs()).sum()
}

fn crab_formation_2(filename: &String) -> (i32, i32) {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let crabs: Vec<i32> = contents.split(",")
    .map(|x| x.parse().unwrap()).collect();

  let pos: f32 = (crabs.iter().sum::<i32>() as f32) / (crabs.len() as f32);
  let fuel_left = calclate_fuel_consumption_2(&crabs, &(pos.floor() as i32));
  let fuel_right = calclate_fuel_consumption_2(&crabs, &(pos.ceil() as i32));

  if fuel_left < fuel_right {
    return (pos.floor() as i32, fuel_left);
  } else {
    return (pos.ceil() as i32, fuel_right);
  }
}

fn calclate_fuel_consumption_2(crabs: &Vec<i32>, position: &i32) -> i32 {
  crabs.iter().map(|c| sum_of_ints(&(c-position).abs())).sum()
}

fn sum_of_ints(i: &i32) -> i32 {
  i * (i+1) / 2
}

#[cfg(test)]
mod tests {
  use super::*;
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn test_1() {
    assert_eq!(crab_formation_1(&INPUT_FILENAME.to_string()), (2, 37));
  }

  #[test]
  fn test_2() {
    assert_eq!(crab_formation_2(&INPUT_FILENAME.to_string()), (5, 168));
  }
}

