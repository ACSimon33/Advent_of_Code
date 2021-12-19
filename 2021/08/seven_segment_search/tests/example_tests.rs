mod day_08 {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use seven_segment_search;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      seven_segment_search::get_amount_of_1478(&INPUT_FILENAME.to_string()),
      26
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      seven_segment_search::sum_all_outputs(&INPUT_FILENAME.to_string()),
      61229
    );
  }
}
