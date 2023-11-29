package com.github.acsimon33.aoc2023.day00

// Import Solution
import com.github.acsimon33.aoc2023.day00.kotlinTemplate.KotlinTemplate
import java.io.File
import java.util.concurrent.TimeUnit
import org.openjdk.jmh.annotations.*

// Puzzle input
const val INPUT_FILENAME: String = "./input/puzzle_input.txt"

@State(Scope.Benchmark)
@Fork(1)
@Warmup(iterations = 2)
@Measurement(iterations = 2, time = 1, timeUnit = TimeUnit.SECONDS)
open class PuzzleBenchmarks {
    // KotlinTemplate App
    val app = KotlinTemplate(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    @Setup fun setUp() {}

    @Benchmark
    fun task1() {
        app.solution1()
    }

    @Benchmark
    fun task2() {
        app.solution2()
    }
}