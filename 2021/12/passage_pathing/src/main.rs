extern crate clap;
use clap::Parser;

/// Day 12: Passage Pathing
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Maximum number of visits per small cave.
  #[clap(short, long, default_value_t = 1)]
  visits: usize
}

// Import puzzle solutions module
mod passage_pathing;

// Main entry point
fn main() {
  let args = Args::parse();

  // Calculate amount of paths
  let n = passage_pathing::get_paths(&args.filename, args.visits);
  println!("Amount of paths: {}", n);
}
