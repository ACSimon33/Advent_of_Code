package aoc2023.day13

// Import solution and testing framework
import aoc2023.day13.pointOfIncidence.PointOfIncidence
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"

/** Example test framework */
class ExampleTest {
    val app = PointOfIncidence(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1() {
        assertEquals(app.reflectionSummary(0), 405, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        assertEquals(app.reflectionSummary(1), 400, "Example result for task 2 is wrong")
    }
}
