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

  let energy = amphipod::least_amount_of_energy(&args.filename);
  println!("Least amount of energy: {}", energy);
}
