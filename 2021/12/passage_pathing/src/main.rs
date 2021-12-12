use std::env;

// Import puzzle solutions module
mod passage_pathing;

// Main entry point
fn main() {
  let args: Vec<String> = env::args().collect();
  if args.len() < 2 {
    panic!("Error: Input file missing.");
  }
  let filename: &String = &args[1];
  if args.len() < 3 {
    panic!("Error: Amount of maximal vsisits is missing.");
  }
  let max_visits: usize = args[2].parse().unwrap();

  // Calculate amount of paths
  let n = passage_pathing::get_paths(&filename, max_visits);
  println!("Amount of paths: {}", n);
}
