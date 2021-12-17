use std::fs;

mod caves;
use caves::CaveSystem;

/// Calculate the number of possible paths through the cave system.
pub fn get_paths(filename: &String, max_visits: usize) -> usize {
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

// Test example inputs against the reference solution
#[cfg(test)]
mod passage_pathing_tests {
  use super::get_paths;
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_2.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_3.txt";

  #[test]
  fn task_1_small() {
    assert_eq!(get_paths(&INPUT_FILENAME_1.to_string(), 1), 10);
  }

  #[test]
  fn task_1_medium() {
    assert_eq!(get_paths(&INPUT_FILENAME_2.to_string(), 1), 19);
  }

  #[test]
  fn task_1_large() {
    assert_eq!(get_paths(&INPUT_FILENAME_3.to_string(), 1), 226);
  }

  #[test]
  fn task_2_small() {
    assert_eq!(get_paths(&INPUT_FILENAME_1.to_string(), 2), 36);
  }

  #[test]
  fn task_2_medium() {
    assert_eq!(get_paths(&INPUT_FILENAME_2.to_string(), 2), 103);
  }

  #[test]
  fn task_2_large() {
    assert_eq!(get_paths(&INPUT_FILENAME_3.to_string(), 2), 3509);
  }
}

