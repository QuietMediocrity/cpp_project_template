set(GCC_COVERAGE_COMPILE_FLAGS "-std=c++2b")
set(GCC_COVERAGE_LINK_FLAGS    "-lgcov")

set(CMAKE_CXX_FLAGS  "${CMAKE_CXX_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS  "${CMAKE_EXE_LINKER_FLAGS} ${GCC_COVERAGE_LINK_FLAGS}")

option(ENABLE_SMTH "" FALSE)
if(ENABLE_SMTH)
        target_compile_options(project_options INTERFACE -f<rule>)
        target_link_options(project_options INTERFACE -f<rule>)
endif()

function(set_project_warnings project_name)
        option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" TRUE)

        set(CLANG_WARNINGS
                -Wall
                -Wextra # reasonable and standard
                -Wshadow # warn the user if a variable declaration shadows one from a parent context
                -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. 
                                   # This helps catch hard to track down memory errors.
                -Wold-style-cast # warn for c-style casts
                -Wcast-align # warn for potential performance problem casts
                -Wunused # warn on anything being unused
                -Woverloaded-virtual # warn if you overload (not override) a virtual function
                -Wpedantic # warn if non-standard C++ is used
                -Wconversion # warn on type conversions that may lose data
                -Wsign-conversion # warn on sign conversions
                -Wnull-dereference # warn if a null dereference is detected
                -Wdouble-promotion # warn if float is implicit promoted to double
                -Wformat=2 # warn on security issues around functions that format output (ie printf)
        )

        if(WARNINGS_AS_ERRORS)
                set(CLANG_WARNINGS ${CLANG_WARNINGS} -Werror)
        endif()

        set(GCC_WARNINGS
                ${CLANG_WARNINGS}

                # info: https://linux.die.net/man/1/g++
                -g # debugging memes
                -O0
                -pedantic
                -pedantic-errors
                -Wdisabled-optimization # warn me if compiler fails to optimize the code (assuming -On, n != 0)
                -Wduplicated-cond # warn if if / else chain has duplicated conditions
                -Wduplicated-branches # warn if if / else branches have duplicated code
                -Weffc++ # warn about violations of the following style guides from Scott Meyers' Effective C++ book:
                        # 11. Define a copy constructor and an assignment operator for classes with dynamically allocated
                        # memory.
                        # 12. Prefer initialization to assignment in constructors.
                        # 14. Make destructors virtual in base classes (-Wnon-virtual-dtor)
                        # 15. Have 'operator=' return reference to '*this'.
                        # 23. Don't try to return reference when you must return an object.
                        # It also warns about violations of the following style guidelines from 'More Effective C++' book:
                        # 6. Distinguish between prefix and postfix forms of increment and decrement operators.
                        # 7. Never overload '&&', '||', or ','
                        # Standard libraries don't follow these rules.
                -Wfloat-equal # warn if floating point values are used in equality comparisons.

                # these help to avoid issues with `print..` and string literals
                -Wformat-nonliteral
                -Wformat-security 
                -Wformat-y2k

                -Winit-self # warn about ``int i = i`` blunders
                -Winline # warn if function declared as 'inline' cannot be inline
                -Winvalid-pch
                -Wlong-long
                -Wmissing-declarations # warn if global function is defined without a previous declaration.
                -Wmissing-format-attribute
                -Wmissing-include-dirs
                -Wmissing-noreturn
                -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
                -Wno-missing-field-initializers
                -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
                -Wredundant-decls
                -Wswitch-default
                -Wswitch-enum
                -Wundef
                -Wunreachable-code
                -Wuseless-cast # warn if you perform a cast to the same type
                -Wvariadic-macros

                # I am too dumb for these:
                # -Wpacked 
                # -Wpadded
                # -fstack-protector
                # -Wstack-protector

                # Parts of -Wextra:
                # -Wmissing-field-initializers
                # -Wunused-parameter
                # -Wuninitialized

                # Extra options for C:
                # -Wbad-function-cast
                # -Wdeclaration-after-statement
                # -Wimplicit
                # -Wold-style-definition
                # -Wmissing-prototypes
                # -Wstrict-prototypes
                # -Wstrict-selector-match
                # -Wundeclared-selector
        )

        if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang")
                set(PROJECT_WARNINGS ${CLANG_WARNINGS})
        elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
                set(PROJECT_WARNINGS ${GCC_WARNINGS})
        else()
                message(AUTHOR_WARNING "No compiler warnings set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
        endif()

        target_compile_options(${project_name} INTERFACE ${PROJECT_WARNINGS})

endfunction()

