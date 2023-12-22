package aoc2023.day19.aplenty

/** Aplenty Solver */
public class Aplenty(input: String) {
    /** Map of all workflows with their IDs. */
    private val workflows: Map<String, Workflow> =
        input
            .split("\r?\n\r?\n".toRegex())[0]
            .lines()
            .map { Workflow(it) }
            .map { Pair(it.id, it) }
            .toMap()

    /** List of all machine parts. */
    private val parts: List<MachinePart> =
        input.split("\r?\n\r?\n".toRegex())[1].trim().lines().map { MachinePart(it) }

    /** First task: Process all parts and sum up the final ratings for all accepted parts. */
    fun sumOfAcceptedFinalRatings(): Long = parts.sumOf { processPart(it, "in") }

    /** Second task: Calculate the number of accepted rating combinations. */
    fun amountOfAcceptedRatings(): Long = processPart(IntervalMachinePart(1L, 4000L), "in")

    /**
     * Process the given machine [part] by applying the [currentWorkflow] to it and calling this
     * function recursively for the next workflow until the [part] is either accepted or rejected.
     * If it is rejected the final rating of the [part] is returned and otherwise zero.
     */
    private fun processPart(part: MachinePart, currentWorkflow: String): Long =
        workflows[currentWorkflow]!!.process(part).let {
            when (it) {
                "A" -> part.finalRating()
                "R" -> 0L
                else -> processPart(part, it)
            }
        }

    /**
     * Process an interval-based machine [part] by applying the [currentWorkflow] to it and calling
     * this function recursively for the next workflows until we end up with an interval which is
     * either completely accepted or rejected. If it is accepted we add the number of rating
     * combinations to the sum.
     */
    private fun processPart(part: IntervalMachinePart, currentWorkflow: String): Long {
        var sumOfCombinations: Long = 0L
        for ((newWorkflow, newPart) in workflows[currentWorkflow]!!.process(part)) {
            when (newWorkflow) {
                "A" -> {
                    sumOfCombinations += newPart.combinations()
                }
                "R" -> continue
                else -> sumOfCombinations += processPart(newPart, newWorkflow)
            }
        }
        return sumOfCombinations
    }
}

/** A complete workflow initialized from [iniStr]. */
private class Workflow(initStr: String) {
    /** The workflow ID. */
    val id: String = Regex("([a-z]+)\\{").find(initStr)!!.groups[1]!!.value

    /** The steps in the workflow. */
    val steps: List<Step> =
        Regex("\\{(.*)\\}").find(initStr)!!.groups[1]!!.value.split(",").dropLast(1).map {
            Step(it)
        }

    /** Final target workflow if all steps failed. */
    val target: String = Regex(",([a-zAR]+)\\}").find(initStr)!!.groups[1]!!.value

    /** Apply the steps to the given [part] and return the ID of the mext workflow. */
    fun process(part: MachinePart): String {
        for (step in steps) {
            if (step.process(part)) {
                return step.target
            }
        }

        return target
    }

    /**
     * Apply the steps to a given interval machine [part]. Returns a list of pairs of new intervals
     * and the IDs of the next workflows which should be applied to them.
     */
    fun process(part: IntervalMachinePart): List<Pair<String, IntervalMachinePart>> {
        var nextWorkflowsAndParts = mutableListOf<Pair<String, IntervalMachinePart>>()
        var currentPart: IntervalMachinePart? = part
        var newParts: Pair<IntervalMachinePart?, IntervalMachinePart?> = Pair(null, null)

        for (step in steps) {
            currentPart?.let { newParts = step.process(it) } ?: break
            newParts.first?.let { nextWorkflowsAndParts.add(Pair(step.target, it)) }
            currentPart = newParts.second
        }

        currentPart?.let { nextWorkflowsAndParts.add(Pair(target, it)) }

        return nextWorkflowsAndParts.toList()
    }
}

/** Class representing a single step in a workflow initialized from [initStr]. */
private class Step(initStr: String) {

    /** The rating which is compared. */
    val rating: Rating = (Rating from initStr[0])!!

    /** The comparison operation which is applied. */
    val comparison: Comparison = (Comparison from initStr[1])!!

    /** The constant value that the rating is compared against. */
    val rhs: Long = Regex("([0-9]+):").find(initStr)!!.groups[1]!!.value.toLong()

    /** The target workflow ID if the comparison evaluated true. */
    val target: String = Regex(":([a-zAR]+)").find(initStr)!!.groups[1]!!.value

    /** Check the specific rating of the given machine [part] and return the result. */
    fun process(part: MachinePart): Boolean = comparison.applyTo(part.ratings[rating.ordinal], rhs)

    /**
     * Check the values in the interval of the specific rating of the given machine [part]. Returns
     * two new machine parts, one for all rating values which passed the check and one for all
     * rating values which failed the check.
     */
    fun process(part: IntervalMachinePart): Pair<IntervalMachinePart?, IntervalMachinePart?> =
        comparison.applyTo(part.ratings[rating.ordinal], rhs).let {
            Pair(part.update(rating, it.first), part.update(rating, it.second))
        }
}

/** Comparison class which can apply the comparison to given values. */
private enum class Comparison {
    LESS {
        /** Return [a] < [b]. */
        override fun applyTo(a: Long, b: Long): Boolean = a < b

        /**
         * Check if the values in the interval [a] are less than [b]. Return two intervals; the
         * first one specifying all values which are less than [b] and the second one specifying all
         * all values greater or equal to [b].
         */
        override fun applyTo(a: Interval, b: Long): Pair<Interval?, Interval?> =
            if (a.end < b) {
                Pair(a, null)
            } else if (a.start < b && a.end >= b) {
                Pair(Interval(a.start, b - 1), Interval(b, a.end))
            } else {
                Pair(null, a)
            }
    },
    GREATER {
        /** Return [a] > [b]. */
        override fun applyTo(a: Long, b: Long): Boolean = a > b

        /**
         * Check if the values in the interval [a] are greater than [b]. Return two intervals; the
         * first one specifying all values which are greater than [b] and the second one specifying
         * all values less or equal to [b].
         */
        override fun applyTo(a: Interval, b: Long): Pair<Interval?, Interval?> =
            if (a.start > b) {
                Pair(a, null)
            } else if (a.start <= b && a.end > b) {
                Pair(Interval(b + 1, a.end), Interval(a.start, b))
            } else {
                Pair(null, a)
            }
    };

    /** Apply the comparison to teh two values [a] and [b]. */
    abstract fun applyTo(a: Long, b: Long): Boolean

    /** Apply the comparison to the interval [a] and the value [b]. */
    abstract fun applyTo(a: Interval, b: Long): Pair<Interval?, Interval?>

    companion object {
        /** Create a comparison from its char [id]. */
        infix fun from(id: Char): Comparison? =
            when (id) {
                '<' -> LESS
                '>' -> GREATER
                else -> null
            }
    }
}

/** Rating enumeration. */
private enum class Rating {
    X,
    M,
    A,
    S;

    companion object {
        /** Create a rating type from its char [id]. */
        infix fun from(id: Char): Rating? =
            when (id) {
                'x' -> X
                'm' -> M
                'a' -> A
                's' -> S
                else -> null
            }
    }
}

/** Machine part with ratings initialized from [initStr]. */
private class MachinePart(initStr: String) {
    val ratings: List<Long> =
        Regex("\\{x=([0-9]+),m=([0-9]+),a=([0-9]+),s=([0-9]+)\\}")
            .find(initStr)!!
            .groups
            .drop(1)
            .map { it!!.value.toLong() }

    /** Return the final rating (sum of all ratings). */
    fun finalRating(): Long = ratings.sum()
}

/** Machine part with interval [ratings]. */
private class IntervalMachinePart(val ratings: List<Interval>) {

    /** Create a machine part with all ratings initialized to the interval ([start], [end]). */
    constructor(start: Long, end: Long) : this(List(4) { Interval(start, end) })

    /** Calculate the amount of rating combinations. */
    fun combinations(): Long = ratings.fold(1) { acc, r -> acc * r.length() }

    /** Update the [interval] of the specified [rating]. Return a new updated machine part. */
    fun update(rating: Rating, interval: Interval?): IntervalMachinePart? =
        interval?.let {
            IntervalMachinePart(
                ratings
                    .toMutableList()
                    .let {
                        it[rating.ordinal] = interval
                        it
                    }
                    .toList()
            )
        }
}

/** Interval defined by a [start] value and an [end] value. */
private data class Interval(val start: Long, val end: Long) {

    /** Length of the interval. */
    fun length(): Long = end - start + 1
}
