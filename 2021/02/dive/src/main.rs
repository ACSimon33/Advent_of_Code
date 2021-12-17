use clap::Parser;

/// Day 2: Dive
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use dive;

fn main() {
  let args = Args::parse();

  let (distance_1, depth_1) = dive::distance_depth(&args.filename);
  println!("1. Final location forward: {}", distance_1);
  println!("1. Final depth: {}", depth_1);
  println!("1. Product: {}", distance_1 * depth_1);

  let (distance_2, depth_2) = dive::distance_depth_with_aim(&args.filename);
  println!("2. Final location forward: {}", distance_2);
  println!("2. Final depth: {}", depth_2);
  println!("2. Product: {}", distance_2 * depth_2);
}
