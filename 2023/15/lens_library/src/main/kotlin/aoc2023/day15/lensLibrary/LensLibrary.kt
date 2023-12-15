package aoc2023.day15.lensLibrary

/** Lens Library Solver */
public class LensLibrary(input: String) {
    private val initializationSteps: List<String> = input.split(",")

    /** First task: Sum up the hash values of all initialization steps. */
    fun sumOfHashes(): Int = initializationSteps.map { hash(it) }.sum()

    /** Second task: Perform all the initialization steps and calculate the focusing power. */
    fun focusingPower(): Int {
        val channel = LightChannel()
        initializationSteps.forEach { channel.performInitStep(it) }
        return channel.focusingPower()
    }
}

/** Calculates a hash value for a given string [str]. */
private fun hash(str: String): Int = str.fold(0, { acc, c -> ((acc + c.code) * 17) % 256 })

/** Class wit data of a lense, i.e. its [label] as well as its [focalLength]. */
private data class Lense(val label: String, val focalLength: Int)

/** A box which can contain an arbitrary abount of lenses. */
private class LenseBox() {
    private val lenses: MutableList<Lense> = mutableListOf()

    /** Insert a given [lense]. If a lense with the same label already exists, replace it. */
    fun insertLense(lense: Lense): Unit {
        val idx = lenses.indexOfFirst { it.label == lense.label }
        if (idx >= 0) {
            lenses[idx] = lense
        } else {
            lenses.add(lense)
        }
    }

    /** Remove a lense with the given [label]. If there isn't a matching lense, do nothing. */
    fun removeLense(label: String): Unit {
        val idx = lenses.indexOfFirst { it.label == label }
        if (idx >= 0) {
            lenses.removeAt(idx)
        }
    }

    /** Calculate the focusing power of the lenses contained in this box. */
    fun focusingPower(): Int = lenses.foldIndexed(0, { i, fp, l -> fp + (i + 1) * l.focalLength })
}

/** A light channel which contains 256 lens boxes which focus the incoming light. */
private class LightChannel() {
    private val boxes: List<LenseBox> = List(256, { LenseBox() })

    /** Perform a given initialization step [str], i.e. either add or remove a lense from a box. */
    fun performInitStep(str: String) {
        val match = Regex("([a-z]*)(-|=)([0-9])?").find(str)!!
        val label: String = match.groups[1]!!.value
        val boxIdx: Int = hash(label)

        when (match.groups[2]!!.value) {
            "-" -> boxes[boxIdx].removeLense(label)
            "=" -> boxes[boxIdx].insertLense(Lense(label, match.groups[3]!!.value.toInt()))
            else -> throw Exception("Unknown initialization operation.")
        }
    }

    /** Calculate the focusing power over all lense boxes. */
    fun focusingPower(): Int =
        boxes.foldIndexed(0, { i, fp, b -> fp + (i + 1) * b.focusingPower() })
}
