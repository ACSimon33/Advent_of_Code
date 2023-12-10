package aoc2023.day10

// Import solution and CLI argument parser
import aoc2023.day10.pipeMaze.PipeMaze
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 10: Pipe Maze") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: PipeMaze = PipeMaze(input.readText(Charsets.UTF_8))

        val result_1: Int = app.furthestPipeSegment()
        println("Distance to furthest pipe segment: $result_1")

        val result_2: Int = app.enclosedArea()
        println("Area enclosed by the loop: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
