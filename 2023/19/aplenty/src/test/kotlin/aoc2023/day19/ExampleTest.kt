package aoc2023.day19

// Import solution and testing framework
import aoc2023.day19.aplenty.Aplenty
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"

/** Example test framework */
class ExampleTest {
    val app = Aplenty(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1() {
        assertEquals(app.sumOfAcceptedFinalRatings(), 19114, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        assertEquals(app.amountOfAcceptedRatings(), 167409079868000, "Example result for task 2 is wrong")
    }
}
