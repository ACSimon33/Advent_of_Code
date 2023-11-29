package com.github.acsimon33.aoc2023.day00

// Import CLI argument parser
import com.github.ajalt.clikt.core.CliktCommand
import com.github.ajalt.clikt.parameters.arguments.argument
import com.github.ajalt.clikt.parameters.types.file

// Import Solution
import com.github.acsimon33.aoc2023.day00.kotlinTemplate.KotlinTemplate

class App : CliktCommand(help = "Day 0: Kotlin Template") {
    val input by argument().file(mustExist = true)

    override fun run() {
        val app: KotlinTemplate = KotlinTemplate(input.readText(Charsets.UTF_8))

        val result_1: Int = app.solution_1()
        println("1. Solution: $result_1")

        val result_2: Int = app.solution_2()
        println("2. Solution: $result_2")
    }
}

fun main(args: Array<String>) = App().main(args)
