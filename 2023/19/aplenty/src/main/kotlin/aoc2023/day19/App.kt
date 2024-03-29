package aoc2023.day19

// Import solution and CLI argument parser
import aoc2023.day19.aplenty.Aplenty
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 19: Aplenty") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: Aplenty = Aplenty(input.readText(Charsets.UTF_8))

        val result_1: Long = app.sumOfAcceptedFinalRatings()
        println("Sum of the final ratings of all accepted parts: $result_1")

        val result_2: Long = app.amountOfAcceptedRatings()
        println("Number of all possible accepted ratings: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
