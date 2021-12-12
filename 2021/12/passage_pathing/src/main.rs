use std::fs;
use std::env;

mod caves;
use caves::CaveSystem;

fn main() {
  let args: Vec<String> = env::args().collect();
  let filename: &String = &args[1];
  let max_visits: usize = args[2].parse().unwrap();

  let n = get_paths(&filename, max_visits);
  println!("Amount of paths: {}", n);
}

fn get_paths(filename: &String, max_visits: usize) -> usize {
  let contents = fs::read_to_string(filename)
    .expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut cave_system: CaveSystem = CaveSystem::new();
  for line in lines.iter() {
    cave_system.add_connection(line);
  }

  let mut looped: bool = false;
  cave_system.traverse(&"start".to_string(), &max_visits, &mut looped);
  return cave_system.caves["end"].visited;
}

#[cfg(test)]
mod tests {
  use super::*;
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_2.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_3.txt";

  #[test]
  fn test_1() {
    assert_eq!(get_paths(&INPUT_FILENAME_1.to_string(), 1), 10);
    assert_eq!(get_paths(&INPUT_FILENAME_2.to_string(), 1), 19);
    assert_eq!(get_paths(&INPUT_FILENAME_3.to_string(), 1), 226);
  }

  #[test]
  fn test_2() {
    assert_eq!(get_paths(&INPUT_FILENAME_1.to_string(), 2), 36);
    assert_eq!(get_paths(&INPUT_FILENAME_2.to_string(), 2), 103);
    assert_eq!(get_paths(&INPUT_FILENAME_3.to_string(), 2), 3509);
  }
}

