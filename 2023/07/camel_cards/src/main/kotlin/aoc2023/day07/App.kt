package aoc2023.day07

// Import solution and CLI argument parser
import aoc2023.day07.camelCards.CamelCards
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 07: Camel Cards") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: CamelCards = CamelCards(input.readText(Charsets.UTF_8))

        val result_1: Int = app.totalWinnings()
        println("Amount of total winnings: $result_1")

        val result_2: Int = app.totalWinningsWithJokers()
        println("Amount of total winnings with Jokers: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
