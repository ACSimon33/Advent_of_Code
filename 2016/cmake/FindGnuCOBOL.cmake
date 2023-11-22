
if(GnuCOBOL_FOUND)
  return()
endif()

set(GnuCOBOL_DIALECT "default" CACHE STRING "Selection of COBOL dialect")
set_property(CACHE GnuCOBOL_DIALECT PROPERTY STRINGS
  "default" "cobol2014" "cobol2002" "cobol85" "xopen" "ibm-strict" "ibm"
  "mvs-strict" "mvs" "mf-strict" "mf" "bs2000-strict" "bs2000" "acu-strict"
  "acu" "rm-strict" "rm")

set(GnuCOBOL_SOURCE_FORMAT "fixed" CACHE STRING "Selection of COBOL format")
set_property(CACHE GnuCOBOL_SOURCE_FORMAT PROPERTY STRINGS "fixed" "free")

# Search for GnuCOBOL transpiler (cobc)
find_program(GnuCOBOL_COBC_EXECUTABLE cobc DOC "GnuCOBOL transpiler")

# Extract version from command "cobc --version"
if(GnuCOBOL_COBC_EXECUTABLE)
  execute_process(
    COMMAND ${GnuCOBOL_COBC_EXECUTABLE} --version
    OUTPUT_VARIABLE cobc_version
    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)

  if(cobc_version MATCHES "^cobc (GnuCOBOL) .*")
    string(REGEX REPLACE
      "cobc (GnuCOBOL) ([.0-9]+).*" "\\1"
      COBC_VERSION "${cobc_version}")
  endif()
  unset(cobc_version)
endif()

# Search for GnuCOBOL runtime library
find_library(GnuCOBOL_LIBRARY cob DOC "GnuCOBOL runtime library")

# Search for GnuCOBOL include directories
find_path(GnuCOBOL_INCLUDE_DIR "libcob.h" DOC "GnuCOBOL include directory")

# Validate GnuCOBOL installation
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GnuCOBOL
  REQUIRED_VARS GnuCOBOL_COBC_EXECUTABLE GnuCOBOL_LIBRARY GnuCOBOL_INCLUDE_DIR
  VERSION_VAR COBC_VERSION
  HANDLE_VERSION_RANGE)

# Create imported targets
if(GnuCOBOL_FOUND)
  if(NOT TARGET GnuCOBOL::COBC)
    add_executable(GnuCOBOL::COBC IMPORTED)
    set_target_properties(GnuCOBOL::COBC PROPERTIES
      IMPORTED_LOCATION "${GnuCOBOL_COBC_EXECUTABLE}")
  endif()

  if(NOT TARGET GnuCOBOL::COBOL)
    add_library(GnuCOBOL::COBOL UNKNOWN IMPORTED GLOBAL)
    set_target_properties(GnuCOBOL::COBOL PROPERTIES
      IMPORTED_LOCATION "${GnuCOBOL_LIBRARY}"
      INTERFACE_INCLUDE_DIRECTORIES "${GnuCOBOL_INCLUDE_DIR}"
      INTERFACE_SYSTEM_INCLUDE_DIRECTORIES "${GnuCOBOL_INCLUDE_DIR}")
  endif()
endif()

# Helper function to setup transpilation targets
macro(GnuCOBOL_transpile target_name)
  set(singleValueArgs C_SOURCES)
  set(multiValueArgs COBOL_SOURCES COMPILE_OPTIONS)
  cmake_parse_arguments(_ARG "" "${singleValueArgs}" "${multiValueArgs}" ${ARGN})

  # Add flag for transpilation
  set(_ARG_COMPILE_OPTIONS ${_ARG_COMPILE_OPTIONS} "-C")
  set(_ARG_COMPILE_OPTIONS ${_ARG_COMPILE_OPTIONS} "-std=${GnuCOBOL_DIALECT}")
  set(_ARG_COMPILE_OPTIONS ${_ARG_COMPILE_OPTIONS} "-${GnuCOBOL_SOURCE_FORMAT}")

  foreach(_cbl_src ${_ARG_COBOL_SOURCES})
    get_filename_component(_filename ${_cbl_src} NAME_WE)
    set(_output_filename ${CMAKE_CURRENT_BINARY_DIR}/${_filename}.c)
    set(_flags ${_ARG_COMPILE_OPTIONS} -o ${_output_filename})

    add_custom_command(
      OUTPUT ${_output_filename}
      COMMAND GnuCOBOL::COBC ${_flags} ${_cbl_src}
      DEPENDS ${_cbl_src}
      BYPRODUCTS ${_output_filename}.h ${_output_filename}.l.h
      COMMENT "Transpiling ${_cbl_src}")

    list(APPEND _c_sources ${_output_filename})
  endforeach()

  add_custom_target(${target_name} DEPENDS ${_c_sources})
  if(_ARG_C_SOURCES)
    set(${_ARG_C_SOURCES} "${_c_sources}")
  endif()
endmacro()

# Add a COBOL executable target
macro(GnuCOBOL_add_executable target_name)
  set(options "WIN32" "MACOSX_BUNDLE" "EXCLUDE_FROM_ALL")
  set(multiValueArgs SOURCES)
  cmake_parse_arguments(_ARG "${options}" "" "${multiValueArgs}" ${ARGN})

  # Propagate options
  set(_options "")
  if(_ARG_WIN32)
    list(APPEND _options "WIN32")
  endif()
  if(_ARG_MACOSX_BUNDLE)
    list(APPEND _options "MACOSX_BUNDLE")
  endif()
  if(_ARG_EXCLUDE_FROM_ALL)
    list(APPEND _options "EXCLUDE_FROM_ALL")
  endif()

  list(LENGTH _ARG_SOURCES _amount_of_sources)
  if(_amount_of_sources GREATER 1)
    set(_bundle_option "-b")
  endif()

  list(POP_FRONT _ARG_SOURCES _first_source_file)

  # Transpile first cobol file as the entry point of the executable
  GnuCOBOL_transpile("${target_name}_transpile_main"
    COBOL_SOURCES ${_first_source_file}
    COMPILE_OPTIONS "-x" ${_bundle_option}
    C_SOURCES _c_main_source)

  # Transpile the rest of the cobol files
  if(_ARG_SOURCES)
    GnuCOBOL_transpile("${target_name}_transpile"
      COBOL_SOURCES ${_ARG_SOURCES}
      COMPILE_OPTIONS ${_bundle_option}
      C_SOURCES _c_sources)
  endif()

  # Create executable from C sources
  add_executable(${target_name} ${_options} ${_c_main_source} ${_c_sources})
  target_link_libraries(${target_name} PRIVATE GnuCOBOL::COBOL)
endmacro()

# Add a COBOL library target
macro(GnuCOBOL_add_library target_name)
  set(options "STATIC" "SHARED" "MODULE" "EXCLUDE_FROM_ALL")
  set(multiValueArgs SOURCES)
  cmake_parse_arguments(_ARG "${options}" "" "${multiValueArgs}" ${ARGN})

  # Propagate options
  set(_options "")
  if(_ARG_STATIC)
    list(APPEND _options "STATIC")
  endif()
  if(_ARG_SHARED)
    list(APPEND _options "SHARED")
  endif()
  if(_ARG_MODULE)
    list(APPEND _options "MODULE")
  endif()
  if(_ARG_EXCLUDE_FROM_ALL)
    list(APPEND _options "EXCLUDE_FROM_ALL")
  endif()

  list(LENGTH _ARG_SOURCES _amount_of_sources)
  if(_amount_of_sources GREATER 1)
    set(_bundle_option "-b")
  endif()

  # Transpile the rest of the cobol files
  GnuCOBOL_transpile("${target_name}_transpile"
    COBOL_SOURCES ${_ARG_SOURCES}
    COMPILE_OPTIONS "-m" ${_bundle_option}
    C_SOURCES _c_sources)

  # Create executable from C sources
  add_library(${target_name} ${_options} ${_c_sources})
  set_target_properties(${target_name} PROPERTIES
    LIBRARY_OUTPUT_NAME "${target_name}"
    PREFIX "")
  target_link_libraries(${target_name} PRIVATE GnuCOBOL::COBOL)
endmacro()
