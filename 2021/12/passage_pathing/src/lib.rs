use std::fs;

mod caves;
use caves::CaveSystem;

/// Calculate the number of possible paths through the cave system.
pub fn get_paths(filename: &String, max_visits: usize) -> usize {
  let contents =
    fs::read_to_string(filename).expect("Couldn't read input file.");
  let lines: Vec<&str> = contents.lines().collect();

  let mut cave_system: CaveSystem = CaveSystem::new();
  for line in lines.iter() {
    cave_system.add_connection(line);
  }

  let mut looped: bool = false;
  cave_system.traverse(&"start".to_string(), &max_visits, &mut looped);
  return cave_system.caves["end"].visited;
}
