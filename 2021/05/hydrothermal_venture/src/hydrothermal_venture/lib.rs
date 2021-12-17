use std::fs;
use std::collections::HashMap;

mod sea_floor;
use sea_floor::SeaFloor;

/// Return the point cloud of vents.
pub fn vent_point_cloud(
  filename: &String, straight: bool
) -> HashMap<usize, i32> {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  
  let lines: Vec<&str> = contents.lines().collect();
  let sea_floor: SeaFloor = SeaFloor::new(&lines);

  return sea_floor.create_point_cloud(straight);
}

// Test example inputs against the reference solution
#[cfg(test)]
mod hydrothermal_venture_tests {
  use super::vent_point_cloud;
  const INPUT_FILENAME: &str = "input/example_input.txt";

  #[test]
  fn task_1() {
    let cloud = vent_point_cloud(&INPUT_FILENAME.to_string(), true);
    assert_eq!(cloud.iter().filter(|(_, &i)| i > 1).count(), 5);
  }

  #[test]
  fn task_2() {
    let cloud = vent_point_cloud(&INPUT_FILENAME.to_string(), false);
    assert_eq!(cloud.iter().filter(|(_, &i)| i > 1).count(), 12);
  }
}
