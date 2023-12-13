/*
 * This file was generated by the Gradle 'init' task.
 *
 * The settings file is used to specify which projects to include in your build.
 * For more detailed information on multi-project builds, please refer to https://docs.gradle.org/8.4/userguide/building_swift_projects.html in the Gradle documentation.
 */

plugins {
    // Apply the foojay-resolver plugin to allow automatic download of JDKs
    id("org.gradle.toolchains.foojay-resolver-convention") version "0.7.0"
    id("org.jetbrains.kotlin.jvm") version "1.9.10" apply false
    id("org.jetbrains.kotlinx.benchmark") version "0.4.9" apply false
    id("com.ncorti.ktfmt.gradle") version "0.15.1" apply false
}

rootProject.name = "advent_of_code_2023"
include("00:kotlin_template")
include("01:trebuchet")
include("02:cube_conundrum")
include("03:gear_ratios")
include("04:scratchcards")
include("05:if_you_give_a_seed_a_fertilizer")
include("06:wait_for_it")
include("07:camel_cards")
include("08:haunted_wasteland")
include("09:mirage_maintenance")
include("10:pipe_maze")
include("11:cosmic_expansion")
include("12:hot_springs")
