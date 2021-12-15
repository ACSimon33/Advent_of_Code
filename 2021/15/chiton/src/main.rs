extern crate clap;
use clap::Parser;

/// Day 15: Chiton
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
mod chiton;

// Main entry point
fn main() {
  let args = Args::parse();

  let ltr = chiton::lowest_total_risk(&args.filename);
  println!("1. Lowest total risk: {}", ltr);

  let ltr_full = chiton::lowest_total_risk_full(&args.filename);
  println!("1. Lowest total risk (full cave): {}", ltr_full);
}
