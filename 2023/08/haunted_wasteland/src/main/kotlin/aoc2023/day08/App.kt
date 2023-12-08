package aoc2023.day08

// Import solution and CLI argument parser
import aoc2023.day08.hauntedWasteland.HauntedWasteland
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 08: Haunted Wasteland") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: HauntedWasteland = HauntedWasteland(input.readText(Charsets.UTF_8))

        val result_1: Int = app.stepsOfSinglePath()
        println("Amount of steps from AAA to ZZZ: $result_1")

        val result_2: Long = app.stepsOfAllPaths()
        println("Amount of steps from all **A to all **Z: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
