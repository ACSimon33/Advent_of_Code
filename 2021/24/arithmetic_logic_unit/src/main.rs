use clap::Parser;

/// Day 24: Arithmetic Logic Unit
#[derive(Parser, Debug)]
#[clap(about, version, author)]
struct Args {
  /// Program file.
  #[clap(short, long)]
  program: String,

  /// Program inputs.
  #[clap(short, long)]
  inputs: Option<String>,
}

// Import puzzle solutions module
use arithmetic_logic_unit;

// Main entry point
fn main() {
  let args = Args::parse();

  if args.inputs.is_some() {
    let (w, x, y, z) = arithmetic_logic_unit::run_program_with_input(
      &args.program,
      &args.inputs.unwrap(),
    );
    println!("Registers: w={}, x={}, y={}, z={}", w, x, y, z);
  } else {
    let model_number =
      arithmetic_logic_unit::maximum_model_number(&args.program);
    println!("Maximum model number: {:?}", model_number);
    let model_number =
      arithmetic_logic_unit::minimum_model_number(&args.program);
    println!("Minimum model number: {:?}", model_number);
  }
}
