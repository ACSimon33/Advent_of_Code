use clap::Parser;

/// Day 18: Snailfish
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use snailfish;

// Main entry point
fn main() {
  let args = Args::parse();

  let magnitude = snailfish::sum_of_all_numbers(&args.filename);
  println!("1. Magnitude of final sum: {}", magnitude);

  let magnitude_max = snailfish::largest_sum(&args.filename);
  println!("2. Largest magnitude: {}", magnitude_max);
}
