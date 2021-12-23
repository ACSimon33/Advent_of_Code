use clap::Parser;

/// Day 22: Reactor Reboot
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// The subspace dimension to consider
  #[clap(short, long, default_value_t = 0)]
  subspace: i64,
}

// Import puzzle solutions module
use reactor_reboot;

// Main entry point
fn main() {
  let args = Args::parse();

  let n = reactor_reboot::count_cubes(&args.filename, args.subspace);
  println!("1. Amount of cubes which are on: {}", n);
}
