package aoc2023.day04.scratchcards

import kotlin.math.pow

/**
 * If the [index] is smaller than the current size of the list, inrement the correponding element by
 * [value]. Otherwise, if the [index] is smaller than the maximum allowed size [maxSize], add a new
 * elements at the end of the list until we reach the [index] where we a add the [value].
 */
fun MutableList<Int>.incrementOrAppend(index: Int, value: Int, maxSize: Int): Unit {
    if (index < size) {
        set(index, get(index) + value)
    } else if (index < maxSize) {
        while (index > size) {
            add(0)
        }
        add(value)
    }
}

/** Scratchcards Solver */
public class Scratchcards(input: String) {
    val lines: List<String> = input.lines()

    /** List of matching winning numbers for each scratchcard. */
    val matches: List<Int> =
        lines.map {
            scatchcardMatches(
                Regex("\\: *([0-9 ]*) *\\|").find(it)!!.groups[1]!!.value,
                Regex("\\| *([0-9 ]*)").find(it)!!.groups[1]!!.value
            )
        }

    /** First task: Sum of all scratchcard scores. */
    fun sumOfScratchcardScores(): Int = matches.sumOf { score(it) }

    /**
     * Second task: Iterate over all scratchcard, adding new scratch cards, depending on the number
     * of matches.
     */
    fun amountOfScratchcards(): Int {
        var amounts: MutableList<Int> = mutableListOf<Int>(0)
        for ((i, points) in matches.withIndex()) {
            amounts.incrementOrAppend(i, 1, matches.size)

            for (j in (i + 1)..(i + points)) {
                amounts.incrementOrAppend(j, amounts[i], matches.size)
            }
        }

        return amounts.sum()
    }

    /**
     * Calculate the amount of numbers in the string [myNumbers] which match one of the winning
     * numbers in the string [winnningNumbers].
     */
    private fun scatchcardMatches(winningNumbers: String, myNumbers: String): Int =
        myNumbers
            .split(" ")
            .filter { it.isNotEmpty() }
            .map { it.toInt() }
            .count {
                winningNumbers.split(" ").filter { it.isNotEmpty() }.map { it.toInt() }.contains(it)
            }

    /** Calculate the score of the scratchcard based on the amount of [matchingNumbers]. */
    private fun score(matchingNumbers: Int): Int =
        if (matchingNumbers == 0) 0 else (2.0).pow(matchingNumbers - 1).toInt()
}
