use std::fs;

mod sea_floor;
use sea_floor::SeaFloor;

/// Calculate the amount of steps until no cucumber can move.
pub fn steps_to_deadlock(filename: &String) -> u32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");

  let mut floor = SeaFloor::from(contents);
  let mut steps: u32 = 1;
  while floor.step() {
    steps += 1;
  }

  return steps;
}
