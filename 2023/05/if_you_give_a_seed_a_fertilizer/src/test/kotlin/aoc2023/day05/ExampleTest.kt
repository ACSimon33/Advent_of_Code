package aoc2023.day05

// Import solution and testing framework
import aoc2023.day05.ifYouGiveASeedAFertilizer.IfYouGiveASeedAFertilizer
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"

/** Example test framework */
class ExampleTest {
    val app = IfYouGiveASeedAFertilizer(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1() {
        assertEquals(app.nearestSeedLocation(), 35, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        assertEquals(app.nearestSeedIntervalLocation(), 46, "Example result for task 2 is wrong")
    }
}
