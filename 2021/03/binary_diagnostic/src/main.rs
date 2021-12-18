use clap::Parser;

/// Day 3: Binary Diagnostic
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use binary_diagnostic;

fn main() {
  let args = Args::parse();

  let (gamma, epsilon) = binary_diagnostic::gamma_and_epsilon(&args.filename);
  println!("1. Gammma: {}", gamma);
  println!("1. Epsilon: {}", epsilon);
  println!("1. Power consumption: {}", gamma * epsilon);

  let (oxygen, co2) = binary_diagnostic::oxygen_and_co2(&args.filename);
  println!("1. Oxygen: {}", oxygen);
  println!("1. CO2: {}", co2);
  println!("1. Life supprt rating: {}", oxygen * co2);
}
