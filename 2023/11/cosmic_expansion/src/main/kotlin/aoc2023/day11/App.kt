package aoc2023.day11

// Import solution and CLI argument parser
import aoc2023.day11.cosmicExpansion.CosmicExpansion
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.clikt.parameters.types.long

class App : CliktCommand(help = "Day 11: Cosmic Expansion") {
    val input by argument().file(mustExist = true)
    val expansion: Long by
        option("-e", "--expansion", help = "expansion of the universe").long().default(2)

    override fun run() {
        val app: CosmicExpansion = CosmicExpansion(input.readText(Charsets.UTF_8))

        val result_1: Long = app.sumOfGalixyDistances(expansion)
        println("Sum of distances between galaxies: $result_1")
    }
}

fun main(args: Array<String>) = App().main(args)
