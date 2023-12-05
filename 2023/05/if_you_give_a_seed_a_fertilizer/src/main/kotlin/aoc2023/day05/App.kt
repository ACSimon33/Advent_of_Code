package aoc2023.day05

// Import solution and CLI argument parser
import aoc2023.day05.ifYouGiveASeedAFertilizer.IfYouGiveASeedAFertilizer
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 05: If You Give A Seed A Fertilizer") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: IfYouGiveASeedAFertilizer =
            IfYouGiveASeedAFertilizer(input.readText(Charsets.UTF_8))

        val result_1: Long = app.nearestSeedLocation()
        println("Nearest seed location (single seeds): $result_1")

        val result_2: Long = app.nearestSeedIntervalLocation()
        println("Nearest seed location (seed intervals): $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
