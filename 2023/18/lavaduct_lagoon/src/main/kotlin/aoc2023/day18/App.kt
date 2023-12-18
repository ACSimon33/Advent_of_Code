package aoc2023.day18

// Import solution and CLI argument parser
import aoc2023.day18.lavaductLagoon.LavaductLagoon
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 18: Lavaduct Lagoon") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: LavaductLagoon = LavaductLagoon(input.readText(Charsets.UTF_8))

        val result_1: Long = app.volumeWithNormalInstructions()
        println("Lagoon volume with normal instructions: $result_1")

        val result_2: Long = app.volumeWithHexadecimalInstructions()
        println("Lagoon volume with hexadecimal instructions: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
