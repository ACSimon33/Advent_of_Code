use clap::Parser;

/// Day 16: Packet Decoder
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,
}

// Import puzzle solutions module
use packet_decoder;

// Main entry point
fn main() {
  let args = Args::parse();

  let ver = packet_decoder::version_numbers(&args.filename);
  println!("1. Sum of version numbers: {}", ver);

  let result = packet_decoder::evaluate(&args.filename);
  println!("2. Result: {}", result);
}
