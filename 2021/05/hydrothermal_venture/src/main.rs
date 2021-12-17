use clap::Parser;

/// Day 5: Hydrothermal Venture
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Input file (e.g. input/puzzle_input.txt)
  #[clap(short, long)]
  filename: String,

  /// Consider only vertical and horizontal vents
  #[clap(short, long)]
  straigth_lines_only: bool
}

// Import puzzle solutions module
use hydrothermal_venture;

fn main() {
  let args = Args::parse();

  let cloud = hydrothermal_venture::vent_point_cloud(
    &args.filename, args.straigth_lines_only);
  println!("1. Number of vents with intensity 1: {}", 
    cloud.iter().filter(|(_, &i)| i > 1).count());
  println!("1. Number of vents with intensity > 1: {}", 
    cloud.iter().filter(|(_, &i)| i > 1).count());
}

