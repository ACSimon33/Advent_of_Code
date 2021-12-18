use clap::Parser;

/// Day 14: Extended Polymerization
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Amount of of simulation steps.
  #[clap(short, long, default_value_t = 1)]
  steps: usize,
}

// Import puzzle solutions module
use extended_polymerization;

// Main entry point
fn main() {
  let args = Args::parse();

  let occurences =
    extended_polymerization::get_elements(&args.filename, &args.steps);
  println!("Occurences:\n{:?}", occurences);
  println!(
    "Max difference: {}",
    occurences.values().max().unwrap() - occurences.values().min().unwrap()
  );
}
