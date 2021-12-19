mod day_19_beacon_scanner {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use beacon_scanner;

  /// Test of part 1.
  #[test]
  fn task_1() {
    assert_eq!(
      beacon_scanner::count_beacons(&INPUT_FILENAME.to_string()),
      79
    );
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    assert_eq!(
      beacon_scanner::manhatten_distance(&INPUT_FILENAME.to_string()),
      3621
    );
  }
}
