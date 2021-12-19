mod day_01_sonar_sweep {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use sonar_sweep;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      sonar_sweep::increasing_measurements(&INPUT_FILENAME.to_string(), 1),
      7
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      sonar_sweep::increasing_measurements(&INPUT_FILENAME.to_string(), 3),
      5
    );
  }
}
