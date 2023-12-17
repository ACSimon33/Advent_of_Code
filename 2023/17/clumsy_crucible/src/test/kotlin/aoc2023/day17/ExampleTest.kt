package aoc2023.day17

// Import solution and testing framework
import aoc2023.day17.clumsyCrucible.ClumsyCrucible
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"
const val INPUT_FILENAME_2: String = "./input/example_input_2.txt"

/** Example test framework */
class ExampleTest {
    /** First task test */
    @Test
    fun task1() {
        val app = ClumsyCrucible(File(INPUT_FILENAME).readText(Charsets.UTF_8))
        assertEquals(app.solution1(), 102, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input1() {
        val app = ClumsyCrucible(File(INPUT_FILENAME).readText(Charsets.UTF_8))
        assertEquals(app.solution2(), 94, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input2() {
        val app = ClumsyCrucible(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.solution2(), 71, "Example result for task 2 is wrong")
    }
}
