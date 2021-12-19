mod day_09_smoke_basin {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME: &str = "input/example_input.txt";

  // Import puzzle solutions module
  use smoke_basin;

  /// Test of part 1.
  #[test]
  fn task_1() {
    let risk = smoke_basin::risk_level(&INPUT_FILENAME.to_string());
    assert_eq!(risk.len(), 4);
    assert_eq!(risk.iter().filter(|&x| *x == 1).count(), 1);
    assert_eq!(risk.iter().filter(|&x| *x == 2).count(), 1);
    assert_eq!(risk.iter().filter(|&x| *x == 6).count(), 2);
  }

  /// Test of part 2.
  #[test]
  fn task_2() {
    let basin = smoke_basin::basins(&INPUT_FILENAME.to_string(), 3);
    assert_eq!(basin.len(), 3);
    assert_eq!(basin.iter().filter(|&x| *x == 9).count(), 2);
    assert_eq!(basin.iter().filter(|&x| *x == 14).count(), 1);
  }
}
