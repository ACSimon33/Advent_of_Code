package aoc2023.day01.trebuchet

/** List of valid digit strings */
val digitStrings: List<String> =
    listOf("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")

/** Trebuchet Solver */
public class Trebuchet(input: String) {
    var lines: List<String> = input.lines()

    /** First task: Find first and last digit in each line and sum them up */
    fun solution1(): Int {
        var result: Int = 0
        lines.forEach {
            for (c in it) {
                if (c.isDigit()) {
                    result += 10 * c.digitToInt()
                    break
                }
            }

            for (c in it.reversed()) {
                if (c.isDigit()) {
                    result += c.digitToInt()
                    break
                }
            }
        }

        return result
    }

    /**
     * Second task: First annotate the first and last digit string and then run the first task
     * again.
     */
    fun solution2(): Int {
        annotateFirstAndLastDigit()
        return solution1()
    }

    /**
     * Replace the first character in the first and last digit string by the corresponding digit.
     */
    fun annotateFirstAndLastDigit(): Unit {
        lines =
            lines.map {
                val firstDigit: IndexedValue<Int>? =
                    digitStrings
                        .map { s -> it.indexOf(s) }
                        .withIndex()
                        .filter { (_, i) -> i >= 0 }
                        .minByOrNull { (_, i) -> i }

                val lastDigit: IndexedValue<Int>? =
                    digitStrings
                        .map { s -> it.lastIndexOf(s) }
                        .withIndex()
                        .filter { (_, i) -> i >= 0 }
                        .maxByOrNull { (_, i) -> i }

                if (firstDigit != null && lastDigit != null) {
                    it.replaceRange(
                            firstDigit.value,
                            firstDigit.value + 1,
                            (firstDigit.index + 1).toString()
                        )
                        .replaceRange(
                            lastDigit.value,
                            lastDigit.value + 1,
                            (lastDigit.index + 1).toString()
                        )
                } else {
                    it
                }
            }
    }
}
