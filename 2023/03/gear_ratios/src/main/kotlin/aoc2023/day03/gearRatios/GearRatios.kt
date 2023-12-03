package aoc2023.day03.gearRatios

import kotlin.math.max
import kotlin.math.min

/** Gear with a list of connections */
data class Gear(val connections: List<Int>)

/** Extend the int range by one in each direction. The range is capped between zero and [end]. */
fun IntRange.extend(end: Int) = IntRange(max(start - 1, 0), min(end, endInclusive + 1))

/** Gear Ratios Solver */
public class GearRatios(input: String) {
    val lines: List<String> = input.lines()

    /** First task: Sum of all valid machine part numbers */
    fun sumOfPartNumbers(): Int {
        var partNumbers: Int = 0

        for ((index, line) in lines.withIndex()) {
            partNumbers +=
                identifyMachineParts(
                        line,
                        lines.elementAtOrNull(index - 1),
                        lines.elementAtOrNull(index + 1)
                    )
                    .sum()
        }

        return partNumbers
    }

    /** Second task: Sum over all gear ratios (gears with exactly two connections) */
    fun sumOfGearRatios(): Int {
        var gearRatios: Int = 0

        for ((index, line) in lines.withIndex()) {
            gearRatios +=
                identifyGears(
                        line,
                        lines.elementAtOrNull(index - 1),
                        lines.elementAtOrNull(index + 1)
                    )
                    .filter { it.connections.size == 2 }
                    .sumBy { it.connections[0] * it.connections[1] }
        }

        return gearRatios
    }

    /**
     * Return valid machine parts numbers (part numbers adjacent to symbols) on the current [line]
     * of the schematic, given the [previous] and [next] line.
     */
    private fun identifyMachineParts(line: String, previous: String?, next: String?): List<Int> =
        Regex("([0-9]*)")
            .findAll(line)
            .filter {
                it.groups[1]!!.value.isNotEmpty() &&
                    (isMaschinePart(previous, it.groups[1]!!.range) ||
                        isMaschinePart(line, it.groups[1]!!.range) ||
                        isMaschinePart(next, it.groups[1]!!.range))
            }
            .map { it.groups[1]!!.value.toInt() }
            .toList()

    /**
     * Check whether a certain index [range] in the current [line] of the schematic contains a
     * machine part (symbol).
     */
    private fun isMaschinePart(line: String?, range: IntRange): Boolean =
        line?.let { Regex("([^0-9.])").find(it.substring(range.extend(line.length - 1))) != null }
            ?: false

    /**
     * Return a complete list of gears (*) on the current [line] of the schematic, given the
     * [previous] and [next] line.
     */
    private fun identifyGears(line: String, previous: String?, next: String?): List<Gear> =
        Regex("(\\*)")
            .findAll(line)
            .filter { it.groups[1]!!.value == "*" }
            .map {
                getGearConnections(previous, it.groups[1]!!.range.start) +
                    getGearConnections(line, it.groups[1]!!.range.start) +
                    getGearConnections(next, it.groups[1]!!.range.start)
            }
            .map { Gear(it.toList()) }
            .toList()

    /**
     * Return a list of part Numbers in the current [line] of the schematic which are adjacent to
     * the gear at a given [position].
     */
    private fun getGearConnections(line: String?, position: Int): List<Int> =
        line?.let {
            Regex("([0-9]*)")
                .findAll(line)
                .filter {
                    it.groups[1]!!.value.isNotEmpty() &&
                        it.groups[1]!!.range.extend(line.length - 1).contains(position)
                }
                .map { it.groups[1]!!.value.toInt() }
                .toList()
        } ?: listOf<Int>()
}
