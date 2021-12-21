use clap::Parser;

/// Day 20: Trench Map
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Amount of steps in the algorithm
  #[clap(short, long)]
  steps: usize,
}

// Import puzzle solutions module
use trench_map;

// Main entry point
fn main() {
  let args = Args::parse();

  let pixels = trench_map::count_lit_pixels(&args.filename, &args.steps);
  println!(
    "Amount of lit pixels after {} steps: {}",
    args.steps, pixels
  );
}
