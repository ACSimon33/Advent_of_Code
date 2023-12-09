package aoc2023.day09.mirageMaintenance

/** Mirage Maintenance Solver */
public class MirageMaintenance(input: String) {
    private val sequences: List<HistorySequence> = input.lines().map { HistorySequence(it) }

    /** First task: Sum over the predicted next values in all sequences. */
    fun sumOfNextValues(): Long = sequences.map { it.next() }.sum()

    /** Second task: Sum over the predicted previous values in all sequences. */
    fun sumOfPreviousValues(): Long = sequences.map { it.previous() }.sum()
}

/**
 * Class which holds a sequence of historical numbers, initialized from [initStr] and provides a way
 * to predict the next and previous values of the sequence.
 */
private class HistorySequence(initStr: String) {
    val sequence: List<Long> = initStr.split(" ").map { it.toLong() }

    /**
     * If all elements in the given sequence [seq] are the same returns same value as all elements
     * in the sequence. If not we create new list with the differences between all elements in the
     * sequence and run the [next] function recursively on the difference sequence. After getting
     * the next difference we add it to the last element of the sequence.
     */
    fun next(seq: List<Long> = sequence): Long {
        val lastElem = seq.last()
        return if (seq.all { it == lastElem }) {
            lastElem
        } else {
            lastElem + next(differenceSequence(seq))
        }
    }

    /**
     * If all elements in the given sequence [seq] are the same returns same value as all elements
     * in the sequence. If not we create new list with the differences between all elements in the
     * sequence and run the [previous] function recursively on the difference sequence. After
     * getting the previous difference we subtract it from the first element of the sequence.
     */
    fun previous(seq: List<Long> = sequence): Long {
        val firstElem = seq.first()
        return if (seq.all { it == firstElem }) {
            firstElem
        } else {
            firstElem - previous(differenceSequence(seq))
        }
    }

    /** Create a list the all the differences in the sequence [seq]. */
    private fun differenceSequence(seq: List<Long>): List<Long> =
        seq.zipWithNext().map { it.second - it.first }
}
