use std::fs;

/// First task.
pub fn solution_1(filename: &String) -> i32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 0;
}

/// Second task.
pub fn solution_2(filename: &String) -> i32 {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let _lines: Vec<&str> = contents.lines().collect();

  return 1;
}
