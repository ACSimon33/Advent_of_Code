use clap::Parser;

/// Day 17: Trick Shot
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use trick_shot;

// Main entry point
fn main() {
  let args = Args::parse();

  let y = trick_shot::heighest_shot(&args.filename);
  println!("1. Maximum height: {}", y);

  let n = trick_shot::distinct_velocities(&args.filename);
  println!("2. Distinct velocity values: {}", n);
}
