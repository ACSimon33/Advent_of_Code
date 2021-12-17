use clap::Parser;

/// Day 6: Lanternfish
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Days in the simulation.
  #[clap(short, long)]
  days: i128
}

// Import puzzle solutions module
use lanternfish;

fn main() {
  let args = Args::parse();

  let population = lanternfish::lanternfish(&args.filename, &args.days);
  println!("Population: {}", population);
}
