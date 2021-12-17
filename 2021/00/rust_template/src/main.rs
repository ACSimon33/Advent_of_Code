use clap::Parser;

/// Day 0: Rust Template
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use rust_template;

// Main entry point
fn main() {
  let args = Args::parse();

  let val_1 = rust_template::solution_1(&args.filename);
  println!("1. Solution: {}", val_1);

  let val_2 = rust_template::solution_2(&args.filename);
  println!("2. Solution: {}", val_2);
}
