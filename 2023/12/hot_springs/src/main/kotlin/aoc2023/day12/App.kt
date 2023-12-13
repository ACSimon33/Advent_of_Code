package aoc2023.day12

// Import solution and CLI argument parser
import aoc2023.day12.hotSprings.HotSprings
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.options.default
import com.github.ajalt.clikt.parameters.options.option
import com.github.ajalt.clikt.parameters.types.file
import com.github.ajalt.clikt.parameters.types.int

class App : CliktCommand(help = "Day 12: Hot Springs") {
    val input by argument().file(mustExist = true)
    val multiplier: Int by
        option("-m", "--multiplier", help = "springs multiplier").int().default(1)

    override fun run() {
        val app: HotSprings = HotSprings(input.readText(Charsets.UTF_8))

        val result: Long = app.sumOfSpringConfigurations(multiplier)
        println("Amount of spring configurations: $result")
    }
}

fun main(args: Array<String>) = App().main(args)
