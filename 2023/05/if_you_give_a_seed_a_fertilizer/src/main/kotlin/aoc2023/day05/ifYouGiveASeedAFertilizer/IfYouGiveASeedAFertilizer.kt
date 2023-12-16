package aoc2023.day05.ifYouGiveASeedAFertilizer

import kotlin.math.max
import kotlin.math.min

/** If You Give A Seed A Fertilizer Solver */
public class IfYouGiveASeedAFertilizer(val input: String) {

    /** Conversion map between seed and soil values. */
    private val seedToSoil =
        ConversionMap(
            Regex("seed-to-soil map:\r?\n([0-9 \r\n]*)\r?\n")
                .find(input)!!
                .groups[1]!!
                .value
                .trim()
                .lines()
        )

    /** Conversion map between soil and fertilizer values. */
    private val soilToFertilizer =
        ConversionMap(
            Regex("soil-to-fertilizer map:\r?\n([0-9 \r\n]*)\r?\n")
                .find(input)!!
                .groups[1]!!
                .value
                .trim()
                .lines()
        )

    /** Conversion map between fertilizer and water values. */
    private val fertilizerToWater =
        ConversionMap(
            Regex("fertilizer-to-water map:\r?\n([0-9 \r\n]*)\r?\n")
                .find(input)!!
                .groups[1]!!
                .value
                .trim()
                .lines()
        )

    /** Conversion map between water and light values. */
    private val waterToLight =
        ConversionMap(
            Regex("water-to-light map:\r?\n([0-9 \r\n]*)\r?\n")
                .find(input)!!
                .groups[1]!!
                .value
                .trim()
                .lines()
        )

    /** Conversion map between light and temperature values. */
    private val lightToTemperature =
        ConversionMap(
            Regex("light-to-temperature map:\r?\n([0-9 \r\n]*)\r?\n")
                .find(input)!!
                .groups[1]!!
                .value
                .trim()
                .lines()
        )

    /** Conversion map between temperature and humidity values. */
    private val temperatureToHumidity =
        ConversionMap(
            Regex("temperature-to-humidity map:\r?\n([0-9 \r\n]*)\r?\n")
                .find(input)!!
                .groups[1]!!
                .value
                .trim()
                .lines()
        )

    /** Conversion map between humidity and location values. */
    private val humidityToLocation =
        ConversionMap(
            Regex("humidity-to-location map:\r?\n([0-9 \r\n]*)$")
                .find(input)!!
                .groups[1]!!
                .value
                .trim()
                .lines()
        )

    /**
     * First task: Treat seed values as intervals of size 1 and convert them to location values.
     * Return the nearest (smllest) location.
     */
    fun nearestSeedLocation(): Long {
        val seeds: List<Interval> =
            Regex("seeds: ([0-9 ]*)").find(input)!!.groups[1]!!.value.split(" ").map {
                Interval(it.toLong())
            }

        return seedsToLocations(seeds).map { it.start }.min()
    }

    /**
     * Second task: Convert entire seed intervals to their corresponding location intervals. Return
     * the nearest (smllest) location over all intervals.
     */
    fun nearestSeedIntervalLocation(): Long {
        val seeds: List<Interval> =
            Regex("seeds: ([0-9 ]*)").find(input)!!.groups[1]!!.value.split(" ").chunked(2).map {
                Interval(it[0].toLong(), it[1].toLong())
            }

        return seedsToLocations(seeds).map { it.start }.min()
    }

    /** Convert [seeds] intervals to location intervals. */
    private fun seedsToLocations(seeds: List<Interval>): List<Interval> =
        seeds
            .let { seedToSoil.apply(it) }
            .let { soilToFertilizer.apply(it) }
            .let { fertilizerToWater.apply(it) }
            .let { waterToLight.apply(it) }
            .let { lightToTemperature.apply(it) }
            .let { temperatureToHumidity.apply(it) }
            .let { humidityToLocation.apply(it) }
}

/** Class that make multiple conversions available which are initialized via [initStr]. */
private class ConversionMap(initStr: List<String>) {
    val conversions: List<Conversion> = initStr.map { Conversion(it.split(" ")) }

    /** Apply all conversions to a list of intervals [sources]. Return the set of new intervals. */
    fun apply(sources: List<Interval>): List<Interval> {
        var converted: MutableList<Interval> = mutableListOf()
        var nonConverted: MutableList<Interval> = sources.toMutableList()

        for (conv in conversions) {
            val nonConvertedOld: List<Interval> = nonConverted.toList()
            nonConverted.clear()

            for (source in nonConvertedOld) {
                val (c, nc) = conv.apply(source)
                if (c.length >= 1L) {
                    converted.add(c)
                }
                nonConverted.addAll(nc)
            }
        }

        return (converted + nonConverted).toList()
    }
}

/** Class that offers a single conversion which are initialized via [initStr]. */
private class Conversion(initStr: List<String>) {

    /** Destination interval. */
    val destination = Interval(initStr[0].toLong(), initStr[2].toLong())

    /** Source interval. */
    val source = Interval(initStr[1].toLong(), initStr[2].toLong())

    /**
     * Apply conversion to a single [src] interval. Return a converted interval if the [src]
     * interval intersects with the [source] interval of the conversion as well as a list of
     * intervals which were no converted.
     */
    fun apply(src: Interval): Pair<Interval, List<Interval>> {
        var intersection: Interval = source.intersect(src)
        val difference: List<Interval> = src / intersection

        intersection += (destination.start - source.start)
        return Pair(intersection, difference)
    }
}

/** Class that offers an interval with a given [start] and [length]. */
private class Interval(var start: Long, val length: Long = 1) {

    /** End of the interval for convenience. */
    var end = start + length

    /** Calculate the intersection interval between this interval and an [other] interval. */
    fun intersect(other: Interval): Interval {
        val new_start = max(start, other.start)
        val new_end = min(end, other.end)

        return Interval(new_start, max(0, new_end - new_start))
    }

    /**
     * Calculate the difference between this interval and an [other] interval. Results in zero, one,
     * or two new intervals.
     */
    operator fun div(other: Interval): List<Interval> {
        return if (other.length == 0L) {
            listOf<Interval>(Interval(start, length))
        } else if (other.start > start && other.end < end) {
            listOf<Interval>(
                Interval(start, other.start - start),
                Interval(other.end, end - other.end)
            )
        } else if (other.start > start) {
            listOf<Interval>(Interval(start, min(other.start, end) - start))
        } else if (other.end < end) {
            listOf<Interval>(Interval(max(other.end, start), end - max(other.end, start)))
        } else {
            listOf<Interval>()
        }
    }

    /** Move the interval by a given [increment]. */
    operator fun plusAssign(increment: Long): Unit {
        start += increment
        end += increment
    }
}
