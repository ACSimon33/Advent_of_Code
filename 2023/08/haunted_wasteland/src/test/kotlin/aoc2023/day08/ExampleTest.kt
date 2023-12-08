package aoc2023.day08

// Import solution and testing framework
import aoc2023.day08.hauntedWasteland.HauntedWasteland
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME_1: String = "./input/example_input.txt"
const val INPUT_FILENAME_2: String = "./input/example_input_2.txt"
const val INPUT_FILENAME_3: String = "./input/example_input_3.txt"

/** Example test framework */
class ExampleTest {
    /** First task test */
    @Test
    fun task1Input1() {
        val app = HauntedWasteland(File(INPUT_FILENAME_1).readText(Charsets.UTF_8))
        assertEquals(app.stepsOfSinglePath(), 2, "Example result for task 1 is wrong")
    }

    /** First task test */
    @Test
    fun task1Input2() {
        val app = HauntedWasteland(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.stepsOfSinglePath(), 6, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input1() {
        val app = HauntedWasteland(File(INPUT_FILENAME_1).readText(Charsets.UTF_8))
        assertEquals(app.stepsOfAllPaths(), 2, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input2() {
        val app = HauntedWasteland(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.stepsOfAllPaths(), 6, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input3() {
        val app = HauntedWasteland(File(INPUT_FILENAME_3).readText(Charsets.UTF_8))
        assertEquals(app.stepsOfAllPaths(), 6, "Example result for task 2 is wrong")
    }
}
