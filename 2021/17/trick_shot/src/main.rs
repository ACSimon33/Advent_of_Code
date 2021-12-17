extern crate clap;
use clap::Parser;

/// Day 17: Trick Shot
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use trick_shot;

// Main entry point
fn main() {
  let args = Args::parse();

  let val_1 = rust_template::solution_1(&args.filename);
  println!("1. Solution: {}", val_1);
}
