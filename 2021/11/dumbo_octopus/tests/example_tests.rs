mod day_11_dumbo_octopus {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use dumbo_octopus;

  /// Test of part 1 (10 steps).
  #[test]
  fn task_1_10() {
    assert_eq!(
      dumbo_octopus::flashes(&INPUT_FILENAME.to_string(), &10),
      204
    );
  }

  /// Test of part 1 (100 steps).
  #[test]
  fn task_1_100() {
    assert_eq!(
      dumbo_octopus::flashes(&INPUT_FILENAME.to_string(), &100),
      1656
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(dumbo_octopus::all_flash(&INPUT_FILENAME.to_string()), 195);
  }
}
