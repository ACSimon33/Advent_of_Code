use clap::Parser;

/// Day 23: Amphipod
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use amphipod;

// Main entry point
fn main() {
  let args = Args::parse();

  let val_1 = amphipod::solution_1(&args.filename);
  println!("1. Solution: {}", val_1);

  let val_2 = amphipod::solution_2(&args.filename);
  println!("2. Solution: {}", val_2);
}
