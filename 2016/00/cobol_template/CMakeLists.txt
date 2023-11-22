# **************************************************************************** #
# Advent of Code 2016 - Day 00: Cobol Template
# **************************************************************************** #
cmake_minimum_required(VERSION 3.15)

project(day_00_cobol_template
  DESCRIPTION "Advent of Code 2016 solution - Day 00"
  LANGUAGES C)

# **************************************************************************** #
# General setup
# **************************************************************************** #
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

# Include common CMake modules
if(CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
  set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/../../cmake")
  include(cmake_build_types)
  find_package(GnuCOBOL REQUIRED)
endif()

# Library / Archive output directory
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib/")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/lib/")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR}/bin/")

# **************************************************************************** #

# Collect Cobol sources
set(cobol_sources ${PROJECT_SOURCE_DIR}/src/cobol_template.cbl)

# Create main executable target
GnuCOBOL_add_executable(cobol_template SOURCES ${cobol_sources})
