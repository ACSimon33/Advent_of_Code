use clap::Parser;

/// Day 25: Sea Cucumber
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use sea_cucumber;

// Main entry point
fn main() {
  let args = Args::parse();

  let steps = sea_cucumber::steps_to_deadlock(&args.filename);
  println!("Steps until deadlock: {}", steps);
}
