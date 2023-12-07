package aoc2023.day07.camelCards

/** Camel Cards Solver */
public class CamelCards(input: String) {
    val lines: List<String> = input.lines()

    /** First task: Sort the poker hands and calculate the amount of winnings. */
    fun totalWinnings(): Int =
        lines
            .map { Hand(it.split(" ")) }
            .sorted()
            .mapIndexed { index, hand -> (index + 1) * hand.bid }
            .sum()

    /** Second task: Sort the poker hands with jokers and calculate the amount of winnings. */
    fun totalWinningsWithJokers(): Int =
        lines
            .map { HandWithJokers(it.split(" ")) }
            .sorted()
            .mapIndexed { index, hand -> (index + 1) * hand.bid }
            .sum()
}

/** Ranking of card values with '*' as the Joker. */
private val cardValues: Map<Char, Int> = "*23456789TJQKA".mapIndexed { i, c -> Pair(c, i) }.toMap()

/** All possible hand types, ranked from weakest to strongest. */
private enum class HandType() {
    HIGH_CARD,
    ONE_PAIR,
    TWO_PAIR,
    THREE_OF_A_KIND,
    FULL_HOUSE,
    FOUR_OF_A_KIND,
    FIVE_OF_A_KIND
}

/** Identify the hand type from the list of [cards]. Handles hands with and without Jokers. */
private fun identifyCards(cards: List<Int>): HandType {
    val jokers: Int = cards.count { it == cardValues['*'] }
    val cardSets = cards.toSet().map { c -> cards.count { it == c } }
    return when (cardSets.size) {
        1 -> HandType.FIVE_OF_A_KIND
        2 -> {
            if (jokers > 0) {
                HandType.FIVE_OF_A_KIND
            } else {
                if (cardSets.contains(4)) {
                    HandType.FOUR_OF_A_KIND
                } else {
                    HandType.FULL_HOUSE
                }
            }
        }
        3 -> {
            if (jokers > 0) {
                if (jokers == 2 || cardSets.contains(3)) {
                    HandType.FOUR_OF_A_KIND
                } else {
                    HandType.FULL_HOUSE
                }
            } else {
                if (cardSets.contains(3)) {
                    HandType.THREE_OF_A_KIND
                } else {
                    HandType.TWO_PAIR
                }
            }
        }
        4 -> {
            if (jokers > 0) {
                HandType.THREE_OF_A_KIND
            } else {
                HandType.ONE_PAIR
            }
        }
        5 -> {
            if (jokers > 0) {
                HandType.ONE_PAIR
            } else {
                HandType.HIGH_CARD
            }
        }
        else -> {
            throw Exception("Hand with invalid amount of cards!")
        }
    }
}

/**
 * Poker hand class which stores the cards, translated from the [cardsStr] string, the bid,
 * translated from the [bidStr] string, as well as the hand type derived from the cards. Implements
 * the Comparable interface to compare the strength of poker hands.
 */
private open class Hand(cardsStr: String, bidStr: String) : Comparable<Hand> {
    val cards: List<Int> = cardsStr.map { cardValues[it]!! }
    val bid: Int = bidStr.toInt()
    val type: HandType = identifyCards(cards)

    /** String list constructor for convenience which separates the elements in [initStr]. */
    constructor(initStr: List<String>) : this(initStr[0], initStr[1])

    /** Interface function to compare the strength of this hand with an [other] hand. */
    override fun compareTo(other: Hand): Int =
        if (type.ordinal != other.type.ordinal) {
            type.ordinal - other.type.ordinal
        } else {
            cards.zip(other.cards).map { it.first - it.second }.filterNot { it == 0 }[0]
        }
}

/**
 * Specialized poker hand class which replaces all the Jacks (J) in the [cardsStr] string with
 * Jokers (*) and passes the new cards as well as the [bidStr] string to the parent Hand class.
 */
private class HandWithJokers(cardsStr: String, bidStr: String) :
    Hand(cardsStr.replace("J", "*"), bidStr) {

    /** String list constructor for convenience which separates the elements in [initStr]. */
    constructor(initStr: List<String>) : this(initStr[0], initStr[1])
}
