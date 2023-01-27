unset(target)
set (target "main")
set (target_main "${target}.cpp")

unset(sources)
set(SOURCES
        # your_source_file.hpp
)

add_executable(${target} ${target_main} ${sources}) 
target_link_libraries(${target} PRIVATE project_warnings project_options) 
