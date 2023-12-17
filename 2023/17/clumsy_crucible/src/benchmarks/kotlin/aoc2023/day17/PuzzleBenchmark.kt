package aoc2023.day17

// Import solution and benchmarking annotations
import aoc2023.day17.clumsyCrucible.ClumsyCrucible
import java.io.File
import java.util.concurrent.TimeUnit
import org.openjdk.jmh.annotations.*

/** Puzzle input */
const val INPUT_FILENAME: String = "./input/puzzle_input.txt"

/** Benchmark framework */
@State(Scope.Benchmark)
@Fork(1)
@Warmup(iterations = 2)
@Measurement(iterations = 2, time = 1, timeUnit = TimeUnit.SECONDS)
open class PuzzleBenchmarks {
    val app = ClumsyCrucible(File(INPUT_FILENAME).readText(Charsets.UTF_8))

    @Setup fun setUp() {}

    /** First task benchmark */
    @Benchmark
    fun task1() {
        app.leastHeatLoss(1, 3)
    }

    /** Second task benchmark */
    @Benchmark
    fun task2() {
        app.leastHeatLoss(4, 10)
    }
}
