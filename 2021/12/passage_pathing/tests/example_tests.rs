mod day_12_passage_pathing {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME_1: &str = "input/example_input_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_2.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_3.txt";

  // Import puzzle solutions module
  use passage_pathing;

  /// Test of part 1 (small cave system).
  #[test]
  fn task_1_small() {
    assert_eq!(
      passage_pathing::get_paths(&INPUT_FILENAME_1.to_string(), 1),
      10
    );
  }

  /// Test of part 1 (medium cave system).
  #[test]
  fn task_1_medium() {
    assert_eq!(
      passage_pathing::get_paths(&INPUT_FILENAME_2.to_string(), 1),
      19
    );
  }

  /// Test of part 1 (small cave system).
  #[test]
  fn task_1_large() {
    assert_eq!(
      passage_pathing::get_paths(&INPUT_FILENAME_3.to_string(), 1),
      226
    );
  }

  /// Test of part 2 (large cave system).
  #[test]
  fn task_2_small() {
    assert_eq!(
      passage_pathing::get_paths(&INPUT_FILENAME_1.to_string(), 2),
      36
    );
  }

  /// Test of part 2 (medium cave system).
  #[test]
  fn task_2_medium() {
    assert_eq!(
      passage_pathing::get_paths(&INPUT_FILENAME_2.to_string(), 2),
      103
    );
  }

  /// Test of part 2 (large cave system).
  #[test]
  fn task_2_large() {
    assert_eq!(
      passage_pathing::get_paths(&INPUT_FILENAME_3.to_string(), 2),
      3509
    );
  }
}
