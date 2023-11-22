cmake_minimum_required(VERSION 3.5)

# Check if this file was already included
if(_build_types_included)
  return()
endif()
set(_build_types_included TRUE)

# Function that prints the current build type as a status message
macro(print_build_type)
  if(CMAKE_BUILD_TYPE)
    message(STATUS "Using build type: '${CMAKE_BUILD_TYPE}'")
  elseif(CMAKE_CONFIGURATION_TYPES)
    string(REPLACE ";" ", " _build_types "${CMAKE_CONFIGURATION_TYPES}")
    message(STATUS "Using build types: ${_build_types}")
  endif()
endmacro()

set(_default_build_type Release)

if(${CMAKE_VERSION} VERSION_GREATER_EQUAL "3.17.0")
  # Default build type for ninja multi-config generator (CMake >= 3.17.0)
  if (CMAKE_GENERATOR MATCHES "Ninja Multi-Config")
    set(CMAKE_DEFAULT_BUILD_TYPE ${_default_build_type})
  endif()
endif()

# Choose the default build type if none is set
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE "${_default_build_type}"
    CACHE STRING "Choose the type of build." FORCE)

  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE
    PROPERTY STRINGS "Debug" "Release" "RelWithDebInfo" "MinSizeRel")

  message(STATUS
    "Setting build type to '${_default_build_type}' as none was specified.")
else()
  print_build_type()
endif()

# **************************************************************************** #

# Cleanup
unset(_build_types)
unset(_default_build_type)
