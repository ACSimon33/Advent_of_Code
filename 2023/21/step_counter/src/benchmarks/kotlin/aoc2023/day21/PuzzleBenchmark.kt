package aoc2023.day21

// Import solution and benchmarking annotations
import aoc2023.day21.stepCounter.StepCounter
import java.io.File
import org.openjdk.jmh.annotations.*

/** Puzzle input */
const val INPUT_FILENAME: String = "./input/puzzle_input.txt"

/** Benchmark framework */
@State(Scope.Benchmark)
open class PuzzleBenchmarks {
    val app = StepCounter(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    @Setup fun setUp() {}

    /** First task benchmark */
    @Benchmark
    fun task1() {
        app.solution1()
    }

    /** Second task benchmark */
    @Benchmark
    fun task2() {
        app.solution2()
    }
}
