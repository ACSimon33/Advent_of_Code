package aoc2023.day15

// Import solution and CLI argument parser
import aoc2023.day15.lensLibrary.LensLibrary
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 15: Lens Library") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: LensLibrary = LensLibrary(input.readText(Charsets.UTF_8))

        val result_1: Int = app.sumOfHashes()
        println("1. Solution: $result_1")

        val result_2: Int = app.focusingPower()
        println("2. Solution: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
