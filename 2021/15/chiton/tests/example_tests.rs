mod day_15_chiton {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use chiton;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(chiton::lowest_total_risk(&INPUT_FILENAME.to_string()), 40);
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      chiton::lowest_total_risk_full(&INPUT_FILENAME.to_string()),
      315
    );
  }
}
