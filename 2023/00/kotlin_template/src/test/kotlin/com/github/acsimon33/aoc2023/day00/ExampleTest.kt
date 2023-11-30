package com.github.acsimon33.aoc2023.day00

// Import solution and testing framework
import com.github.acsimon33.aoc2023.day00.kotlinTemplate.KotlinTemplate
import java.io.File
import kotlin.test.Test
import kotlin.test.assertEquals

/** Example input */
const val INPUT_FILENAME: String = "./input/example_input.txt"

/** Example test framework */
class ExampleTest {
    val app = KotlinTemplate(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    /** First task test */
    @Test
    fun task1() {
        assertEquals(app.solution1(), 0, "Example result for task 1 is wrong")
    }

    /** Second task test */
    @Test
    fun task2() {
        assertEquals(app.solution2(), 1, "Example result for task 2 is wrong")
    }
}
