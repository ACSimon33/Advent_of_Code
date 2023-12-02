package aoc2023.day01

// Import solution and testing framework
import aoc2023.day01.trebuchet.Trebuchet
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME_1: String = "./input/example_input_1.txt"
const val INPUT_FILENAME_2: String = "./input/example_input_2.txt"

/** Example test framework */
class ExampleTest {
    /** First task test */
    @Test
    fun task1() {
        val app = Trebuchet(File(INPUT_FILENAME_1).readText(Charsets.UTF_8))
        assertEquals(app.sumOfCalibrationValues(), 142, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        val app = Trebuchet(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.sumOfLiteralCalibrationValues(), 281, "Example result for task 2 is wrong")
    }
}
