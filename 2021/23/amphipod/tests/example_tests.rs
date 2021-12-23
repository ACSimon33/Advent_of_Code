mod day_23_amphipod {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_2.txt";

  // Import puzzle solutions module
  use amphipod;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      amphipod::least_amount_of_energy(&INPUT_FILENAME_1.to_string()),
      12521
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      amphipod::least_amount_of_energy(&INPUT_FILENAME_2.to_string()),
      44169
    );
  }
}
