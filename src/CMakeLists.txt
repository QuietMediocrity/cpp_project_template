set(SOURCES
        # your_source_file.hpp
)

add_executable(your_executable_name main.cpp ${SOURCES})
target_link_libraries(your_executable_name PRIVATE project_warnings project_options) 
