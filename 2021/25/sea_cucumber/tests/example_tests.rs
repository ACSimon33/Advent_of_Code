mod day_25_sea_cucumber {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use sea_cucumber;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      sea_cucumber::steps_to_deadlock(&INPUT_FILENAME.to_string()),
      58
    );
  }
}
