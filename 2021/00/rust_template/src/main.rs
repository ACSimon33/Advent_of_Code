use std::env;

// Import puzzle solutions module
mod rust_template;

// Main entry point
fn main() {
  let args: Vec<String> = env::args().collect();
  if args.len() < 2 {
    panic!("Error: Input file missing.");
  }
  let filename: &String = &args[1];

  let val_1 = rust_template::solution_1(&filename);
  println!("1. Solution: {}", val_1);

  let val_2 = rust_template::solution_2(&filename);
  println!("2. Solution: {}", val_2);
}