use clap::Parser;

/// Day 4: Giant Squid
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String
}

// Import puzzle solutions module
use giant_squid;

fn main() {
  let args = Args::parse();

  let (score1, last_num1) = giant_squid::first_winning_board(&args.filename);
  println!("1. Sum of unchecked numbers on winning board: {}", score1);
  println!("1. Winning number: {}", last_num1);
  println!("1. Result: {}", score1 * last_num1);

  let (score2, last_num2) = giant_squid::last_winning_board(&args.filename);
  println!("2. Sum of unchecked numbers on winning board: {}", score2);
  println!("2. Winning number: {}", last_num2);
  println!("2. Result: {}", score2 * last_num2);
}
