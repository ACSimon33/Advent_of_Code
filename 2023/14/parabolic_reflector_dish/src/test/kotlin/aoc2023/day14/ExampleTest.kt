package aoc2023.day14

// Import solution and testing framework
import aoc2023.day14.parabolicReflectorDish.ParabolicReflectorDish
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"

/** Example test framework */
class ExampleTest {
    val app = ParabolicReflectorDish(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1() {
        assertEquals(app.beamLoad(), 136, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        assertEquals(app.beamLoadAfter(1000000000), 64, "Example result for task 2 is wrong")
    }
}
