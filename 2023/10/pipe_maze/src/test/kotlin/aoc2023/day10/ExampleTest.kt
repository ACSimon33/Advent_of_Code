package aoc2023.day10

// Import solution and testing framework
import aoc2023.day10.pipeMaze.PipeMaze
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME_1: String = "./input/example_input.txt"
const val INPUT_FILENAME_2: String = "./input/example_input_2.txt"
const val INPUT_FILENAME_3: String = "./input/example_input_3.txt"
const val INPUT_FILENAME_4: String = "./input/example_input_4.txt"
const val INPUT_FILENAME_5: String = "./input/example_input_5.txt"
const val INPUT_FILENAME_6: String = "./input/example_input_6.txt"
const val INPUT_FILENAME_7: String = "./input/example_input_7.txt"
const val INPUT_FILENAME_8: String = "./input/example_input_8.txt"

/** Example test framework */
class ExampleTest {
    /** First task test */
    @Test
    fun task1Input1() {
        val app = PipeMaze(File(INPUT_FILENAME_1).readText(Charsets.UTF_8))
        assertEquals(app.furthestPipeSegment(), 4, "Example result for task 1 is wrong")
    }

    /** First task test */
    @Test
    fun task1Input2() {
        val app = PipeMaze(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.furthestPipeSegment(), 4, "Example result for task 1 is wrong")
    }

    /** First task test */
    @Test
    fun task1Input3() {
        val app = PipeMaze(File(INPUT_FILENAME_3).readText(Charsets.UTF_8))
        assertEquals(app.furthestPipeSegment(), 8, "Example result for task 1 is wrong")
    }

    /** First task test */
    @Test
    fun task1Input4() {
        val app = PipeMaze(File(INPUT_FILENAME_4).readText(Charsets.UTF_8))
        assertEquals(app.furthestPipeSegment(), 8, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input1() {
        val app = PipeMaze(File(INPUT_FILENAME_1).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 1, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input2() {
        val app = PipeMaze(File(INPUT_FILENAME_2).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 1, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input3() {
        val app = PipeMaze(File(INPUT_FILENAME_3).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 1, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input4() {
        val app = PipeMaze(File(INPUT_FILENAME_4).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 1, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input5() {
        val app = PipeMaze(File(INPUT_FILENAME_5).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 4, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input6() {
        val app = PipeMaze(File(INPUT_FILENAME_6).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 4, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input7() {
        val app = PipeMaze(File(INPUT_FILENAME_7).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 8, "Example result for task 2 is wrong")
    }

    /** Second task test */
    @Test
    fun task2Input8() {
        val app = PipeMaze(File(INPUT_FILENAME_8).readText(Charsets.UTF_8))
        assertEquals(app.enclosedArea(), 10, "Example result for task 2 is wrong")
    }
}
