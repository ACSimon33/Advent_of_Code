extern crate clap;
use clap::Parser;

/// Day 1: Sonar Sweep
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Size of the sliding window
  #[clap(short, long, default_value_t = 1)]
  window: usize,
}

// Import puzzle solutions module
use sonar_sweep;

/// Main entry point for the Sonar Sweep executable
fn main() {
  let args = Args::parse();
  let n = sonar_sweep::increasing_measurements(&args.filename, args.window);
  println!("Amount of increasing measurements: {}", n);
}
