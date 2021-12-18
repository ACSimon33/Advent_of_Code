use clap::Parser;

/// Day 9: Smoke Basin
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Amount of basins.
  #[clap(short, long)]
  basins: usize,
}

// Import puzzle solutions module
use smoke_basin;

fn main() {
  let args = Args::parse();

  let risk = smoke_basin::risk_level(&args.filename);
  println!("1. Amount of low points: {}", risk.len());
  println!("1. Risk level: {}", risk.iter().sum::<i32>());

  let basin = smoke_basin::basins(&args.filename, args.basins);
  println!("2. {} largest basins: {:?}", basin.len(), basin);
  println!("2. Product: {}", basin.iter().product::<usize>());
}
