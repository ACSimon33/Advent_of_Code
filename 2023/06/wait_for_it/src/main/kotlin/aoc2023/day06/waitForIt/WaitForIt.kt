package aoc2023.day06.waitForIt

import kotlin.math.ceil
import kotlin.math.floor
import kotlin.math.max
import kotlin.math.sqrt

/** Wait For It Solver */
public class WaitForIt(input: String) {
    val lines: List<String> = input.lines()

    /** First task: Calculate the amount of wins for each race and multiply them together. */
    fun amoutOfWinsMultipleRaces(): Long {
        val times: List<Double> =
            Regex("Time:\\s+([0-9\\s]*)")
                .find(lines[0])!!
                .groups[1]!!
                .value
                .trim()
                .split("\\s+".toRegex())
                .map { it.toDouble() }
        val distances: List<Double> =
            Regex("Distance:\\s+([0-9\\s]*)")
                .find(lines[1])!!
                .groups[1]!!
                .value
                .trim()
                .split("\\s+".toRegex())
                .map { it.toDouble() }

        return times.zip(distances).map { amountOfWins(it.first, it.second) }.reduce(Long::times)
    }

    /** Second task: Calculate the amount of wins for the single long race. */
    fun amoutOfWinsSingleRace(): Long {
        val times: Double =
            Regex("Time:\\s+([0-9\\s]*)")
                .find(lines[0])!!
                .groups[1]!!
                .value
                .replace(" ", "")
                .toDouble()
        val distances: Double =
            Regex("Distance:\\s+([0-9\\s]*)")
                .find(lines[1])!!
                .groups[1]!!
                .value
                .replace(" ", "")
                .toDouble()

        return amountOfWins(times, distances)
    }

    /**
     * Calculate the amount of wins for a single race with a given [time] and highscore [distance].
     * Solves the following quadratic formula with T = [time], d = [distance] and x = buttonTime:
     * x * (T - x) > d <=> x^2 - T * x + d > 0
     *
     * => 0.5 * (T - sqrt(T^2 - 4 * d)) < x < 0.5 * (T + sqrt(T^2 - 4 * d)) => ⌊0.5 * (T -
     * sqrt(T^2 - 4 * d))⌋ + 1 < x < ⌈0.5 * (T + sqrt(T^2 - 4 * d))⌉ - 1
     */
    private fun amountOfWins(time: Double, distance: Double): Long {
        val minButtonHold: Long = floor(time / 2 - sqrt(time * time / 4 - distance)).toLong() + 1
        val maxButtonHold: Long = ceil(time / 2 + sqrt(time * time / 4 - distance)).toLong() - 1
        return max(maxButtonHold - minButtonHold + 1, 0)
    }
}
