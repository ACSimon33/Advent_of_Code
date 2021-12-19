use std::collections::HashMap;
use std::fs;

mod sea_floor;
use sea_floor::SeaFloor;

/// Return the point cloud of vents.
pub fn vent_point_cloud(
  filename: &String,
  straight: bool,
) -> HashMap<usize, i32> {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let lines: Vec<&str> = contents.lines().collect();
  let sea_floor: SeaFloor = SeaFloor::new(&lines);

  return sea_floor.create_point_cloud(straight);
}
