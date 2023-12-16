package aoc2023.day13

// Import solution and CLI argument parser
import aoc2023.day13.pointOfIncidence.PointOfIncidence
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

class App : CliktCommand(help = "Day 13: Point of Incidence") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: PointOfIncidence = PointOfIncidence(input.readText(Charsets.UTF_8))

        val result_1: Int = app.reflectionSummary(0)
        println("Reflection summary for perfect mirrors: $result_1")

        val result_2: Int = app.reflectionSummary(1)
        println("Reflection summary for mirrors with one smudge: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
