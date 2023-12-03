package aoc2023.day03

// Import solution and testing framework
import aoc2023.day03.gearRatios.GearRatios
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"

/** Example test framework */
class ExampleTest {
    val app = GearRatios(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1() {
        assertEquals(app.sumOfPartNumbers(), 4361, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        assertEquals(app.sumOfGearRatios(), 467835, "Example result for task 2 is wrong")
    }
}
