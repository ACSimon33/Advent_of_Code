mod day_10_syntax_scoring {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use syntax_scoring;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      syntax_scoring::error_score(&INPUT_FILENAME.to_string()),
      26397
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      syntax_scoring::completion_score(&INPUT_FILENAME.to_string()),
      288957
    );
  }
}
