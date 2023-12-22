package aoc2023.day20

// Import solution and testing framework
import aoc2023.day20.pulsePropagation.PulsePropagation
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME_1: String = "./input/example_input.txt"
const val INPUT_FILENAME_2: String = "./input/example_input_2.txt"

/** Example test framework */
class ExampleTest {
    /** First task test */
    @Test
    fun task1Input1() {
        val app = PulsePropagation(File(INPUT_FILENAME_1).readText(Charsets.UTF_8))
        assertEquals(app.solution1(), 32000000, "Example result for task 1 is wrong")
    }

    /** First task test */
    @Test
    fun task1Input2() {
        val app = PulsePropagation(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.solution1(), 11687500, "Example result for task 1 is wrong")
    }
}
