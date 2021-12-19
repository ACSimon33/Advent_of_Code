mod day_03_binary_diagnostic {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use binary_diagnostic;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      binary_diagnostic::gamma_and_epsilon(&INPUT_FILENAME.to_string()),
      (22, 9)
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      binary_diagnostic::oxygen_and_co2(&INPUT_FILENAME.to_string()),
      (23, 10)
    );
  }
}
