set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_C_COMPILER clang-17)
set(CMAKE_CXX_COMPILER clang++-17)
message(STATUS "Using compiler: ${CMAKE_CXX_COMPILER}")

# Supported options: bfd gold lld mold
set(Linker mold)
add_link_options(-fuse-ld=${Linker})
message(STATUS "Using linker: ${Linker}")
