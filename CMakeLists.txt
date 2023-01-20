cmake_minimum_required(VERSION 3.25.1)

project(project_name CXX)

include(cmake/StandardProjectSettings.cmake)
include(cmake/PreventInSourceBuilds.cmake)

add_library(project_options INTERFACE)
target_compile_features(project_options INTERFACE cxx_std_23)

if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
        option(ENABLE_BUILD_WITH_TIME_TRACE "Enable -ftime-trace to generate time tracing .json files on clang" OFF)
        if(ENABLE_BUILD_WITH_TIME_TRACE)
                add_compile_definitions(project_options INTERFACE -ftime-trace)
        endif()
endif()

add_library(project_warnings INTERFACE)

include(cmake/Cache.cmake)
include(cmake/CompilerWarnings.cmake)
set_project_warnings(project_warnings)

# no sanitizers enabled by default
include(cmake/Sanitizers.cmake)
enable_sanitizers(project_options)

# no static analyzers are enabled by default
include(cmake/StaticAnalyzers.cmake)

option(ENABLE_PCH "Enable precompiled headers" OFF)
if(ENABLE_PCH)
        include(cmake/PCH.cmake)
endif()

option(ENABLE_TPL "Enable third-party libraries" OFF)
if(ENABLE_TPL)
        include(cmake/TPL.cmake)
endif()

add_subdirectory(src)

