package aoc2023.day11

// Import solution and testing framework
import aoc2023.day11.cosmicExpansion.CosmicExpansion
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"

/** Example test framework */
class ExampleTest {
    val app = CosmicExpansion(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1() {
        assertEquals(app.sumOfGalixyDistances(2), 374, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Expansion10() {
        assertEquals(app.sumOfGalixyDistances(10), 1030, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Expansion100() {
        assertEquals(app.sumOfGalixyDistances(100), 8410, "Example result for task 2 is wrong")
    }
}
