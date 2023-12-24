package aoc2023.day23

// Import solution and CLI argument parser
import aoc2023.day23.aLongWalk.ALongWalk
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 23: A Long Walk") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: ALongWalk = ALongWalk(input.readText(Charsets.UTF_8))

        val result_1: Int = app.longestPathWithSlopes()
        println("Longest path with icy slopes: $result_1")

        val result_2: Int = app.longestPathWithoutSlopes()
        println("Longest path without the slopes: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
