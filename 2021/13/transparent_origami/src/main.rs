extern crate clap;
use clap::Parser;

/// Day 13: Transparent Origami
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use transparent_origami;

// Main entry point
fn main() {
  let args = Args::parse();

  let n = transparent_origami::first_fold(&args.filename);
  println!("1. Points after the first fold: {}", n);

  let code = transparent_origami::gen_code(&args.filename);
  print!("2. Code:\n{}", code);
}
