use clap::Parser;

/// Day 19: Beacon Scanner
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use beacon_scanner;

// Main entry point
fn main() {
  let args = Args::parse();

  let n = beacon_scanner::count_beacons(&args.filename);
  println!("1. Amount of beacons: {}", n);

  let distance = beacon_scanner::manhatten_distance(&args.filename);
  println!("2. Largest manhatten distance: {}", distance);
}
