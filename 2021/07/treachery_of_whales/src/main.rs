use clap::Parser;

/// Day 7: The Treachery of Whales
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use treachery_of_whales;

fn main() {
  let args = Args::parse();

  let (pos_1, fuel_1) = treachery_of_whales::crab_formation_1(&args.filename);
  println!("1. Position: {}", pos_1);
  println!("1. Fuel Consumption: {}", fuel_1);

  let (pos_2, fuel_2) = treachery_of_whales::crab_formation_2(&args.filename);
  println!("2. Position: {}", pos_2);
  println!("2. Fuel Consumption: {}", fuel_2);
}
