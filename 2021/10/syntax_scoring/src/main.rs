extern crate clap;
use clap::Parser;

/// Day 0: Rust Template
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use syntax_scoring;

// Main entry point
fn main() {
  let args = Args::parse();

  let e_score = syntax_scoring::error_score(&args.filename);
  println!("1. Error score: {}", e_score);

  let c_score = syntax_scoring::completion_score(&args.filename);
  println!("2. Completion score: {}", c_score);
}
