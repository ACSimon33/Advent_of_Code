use clap::Parser;

/// Day 21: Dirac Dice
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use dirac_dice;

// Main entry point
fn main() {
  let args = Args::parse();

  let (p, n) = dirac_dice::deterministic_die(&args.filename);
  println!("1. Losing points: {}", p);
  println!("1. Rolls: {}", n);
  println!("1. Product: {}", p * n);

  let (wins1, wins2) = dirac_dice::quantum_die(&args.filename);
  println!("2. Player 1 wins: {}", wins1);
  println!("2. Player 2 wins: {}", wins2);
}
