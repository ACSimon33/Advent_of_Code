package aoc2023.day04

// Import solution and CLI argument parser
import aoc2023.day04.scratchcards.Scratchcards
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 04: Scratchcards") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: Scratchcards = Scratchcards(input.readText(Charsets.UTF_8))

        val result_1: Int = app.sumOfScratchcardScores()
        println("Sum of scratchcard scores: $result_1")

        val result_2: Int = app.amountOfScratchcards()
        println("Amount of scratchcards: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
