mod day_07_treachery_of_whales {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use treachery_of_whales;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      treachery_of_whales::crab_formation_1(&INPUT_FILENAME.to_string()),
      (2, 37)
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      treachery_of_whales::crab_formation_2(&INPUT_FILENAME.to_string()),
      (5, 168)
    );
  }
}
