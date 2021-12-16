extern crate clap;
use clap::Parser;

/// Day 11: Dumbo Octopus
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Amount of simulation steps.
  #[clap(short, long)]
  steps: usize
}

// Import puzzle solutions module
use dumbo_octopus;

// Main entry point
fn main() {
  let args = Args::parse();

  let n_flashes = dumbo_octopus::flashes(&args.filename, &args.steps);
  println!("1. Amount of flashes after {} steps: {}", args.steps, n_flashes);

  let steps = dumbo_octopus::all_flash(&args.filename);
  println!("2. All octopus flash after {} steps.", steps);
}
