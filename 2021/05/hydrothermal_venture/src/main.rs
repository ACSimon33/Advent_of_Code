use std::fs;
use std::env;

mod sea_floor;
use sea_floor::SeaFloor;
use sea_floor::init_sea_floor;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename = &args[1];
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  
  let lines: Vec<&str> = contents.lines().collect();
  let sea_floor: SeaFloor = init_sea_floor(&lines);
  let straight_line_point_cloud = sea_floor.create_point_cloud(true);

  println!("1. Number of vents with intensity 1: {}", 
    straight_line_point_cloud.iter().filter(|p| p.intensity == 1).count());
  println!("1. Number of vents with intensity > 1: {}", 
    straight_line_point_cloud.iter().filter(|p| p.intensity > 1).count());

  let full_point_cloud = sea_floor.create_point_cloud(false);
  println!("2. Number of vents with intensity 1: {}", 
    full_point_cloud.iter().filter(|p| p.intensity == 1).count());
  println!("2. Number of vents with intensity > 1: {}", 
    full_point_cloud.iter().filter(|p| p.intensity > 1).count());
}

