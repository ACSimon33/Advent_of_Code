package aoc2023.day15

// Import solution and testing framework
import aoc2023.day15.lensLibrary.LensLibrary
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"
const val INPUT_FILENAME_2: String = "./input/example_input_2.txt"

/** Example test framework */
class ExampleTest {
    val app = LensLibrary(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1Input1() {
        val app = LensLibrary(File(INPUT_FILENAME).readText(Charsets.UTF_8))
        assertEquals(app.sumOfHashes(), 1320, "Example result for task 1 is wrong")
    }

    /** First task test */
    @Test
    fun task1Input2() {
        val app = LensLibrary(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.sumOfHashes(), 52, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        val app = LensLibrary(File(INPUT_FILENAME).readText(Charsets.UTF_8))
        assertEquals(app.focusingPower(), 145, "Example result for task 2 is wrong")
    }
}
