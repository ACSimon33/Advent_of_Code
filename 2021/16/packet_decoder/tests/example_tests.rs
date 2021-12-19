mod day_16_packet_decoder {
  use pretty_assertions::assert_eq;

  // Example input
  const INPUT_FILENAME_1: &str = "input/example_input_1_1.txt";
  const INPUT_FILENAME_2: &str = "input/example_input_1_2.txt";
  const INPUT_FILENAME_3: &str = "input/example_input_1_3.txt";
  const INPUT_FILENAME_4: &str = "input/example_input_1_4.txt";
  const INPUT_FILENAME_5: &str = "input/example_input_1_5.txt";
  const INPUT_FILENAME_2_1: &str = "input/example_input_2_1.txt";
  const INPUT_FILENAME_2_2: &str = "input/example_input_2_2.txt";
  const INPUT_FILENAME_2_3: &str = "input/example_input_2_3.txt";
  const INPUT_FILENAME_2_4: &str = "input/example_input_2_4.txt";
  const INPUT_FILENAME_2_5: &str = "input/example_input_2_5.txt";
  const INPUT_FILENAME_2_6: &str = "input/example_input_2_6.txt";
  const INPUT_FILENAME_2_7: &str = "input/example_input_2_7.txt";
  const INPUT_FILENAME_2_8: &str = "input/example_input_2_8.txt";

  // Import puzzle solutions module
  use packet_decoder;

  /// Test of part 1 (input 1).
  #[test]
  fn task_1_1() {
    assert_eq!(
      packet_decoder::version_numbers(&INPUT_FILENAME_1.to_string()),
      6
    );
  }

  /// Test of part 1 (input 2).
  #[test]
  fn task_1_2() {
    assert_eq!(
      packet_decoder::version_numbers(&INPUT_FILENAME_2.to_string()),
      16
    );
  }

  /// Test of part 1 (input 3).
  #[test]
  fn task_1_3() {
    assert_eq!(
      packet_decoder::version_numbers(&INPUT_FILENAME_3.to_string()),
      12
    );
  }

  /// Test of part 1 (input 4).
  #[test]
  fn task_1_4() {
    assert_eq!(
      packet_decoder::version_numbers(&INPUT_FILENAME_4.to_string()),
      23
    );
  }

  /// Test of part 1 (input 5).
  #[test]
  fn task_1_5() {
    assert_eq!(
      packet_decoder::version_numbers(&INPUT_FILENAME_5.to_string()),
      31
    );
  }

  /// Test of part 2 (input 1).
  #[test]
  fn task_2_1() {
    assert_eq!(packet_decoder::evaluate(&INPUT_FILENAME_2_1.to_string()), 3);
  }

  /// Test of part 2 (input 2).
  #[test]
  fn task_2_2() {
    assert_eq!(
      packet_decoder::evaluate(&INPUT_FILENAME_2_2.to_string()),
      54
    );
  }

  /// Test of part 2 (input 3).
  #[test]
  fn task_2_3() {
    assert_eq!(packet_decoder::evaluate(&INPUT_FILENAME_2_3.to_string()), 7);
  }

  /// Test of part 2 (input 4).
  #[test]
  fn task_2_4() {
    assert_eq!(packet_decoder::evaluate(&INPUT_FILENAME_2_4.to_string()), 9);
  }

  /// Test of part 2 (input 5).
  #[test]
  fn task_2_5() {
    assert_eq!(packet_decoder::evaluate(&INPUT_FILENAME_2_5.to_string()), 1);
  }

  /// Test of part 2 (input 6).
  #[test]
  fn task_2_6() {
    assert_eq!(packet_decoder::evaluate(&INPUT_FILENAME_2_6.to_string()), 0);
  }

  /// Test of part 2 (input 7).
  #[test]
  fn task_2_7() {
    assert_eq!(packet_decoder::evaluate(&INPUT_FILENAME_2_7.to_string()), 0);
  }

  /// Test of part 2 (input 8).
  #[test]
  fn task_2_8() {
    assert_eq!(packet_decoder::evaluate(&INPUT_FILENAME_2_8.to_string()), 1);
  }
}
