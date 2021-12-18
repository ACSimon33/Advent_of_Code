use clap::Parser;

/// Day 8: Seven Segment Search
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use seven_segment_search;

fn main() {
  let args = Args::parse();

  let n = seven_segment_search::get_amount_of_1478(&args.filename);
  println!("1. Amount of 1, 4, 7 and 8: {}", n);

  let s = seven_segment_search::sum_all_outputs(&args.filename);
  println!("1. Sum of all outputs: {}", s);
}
