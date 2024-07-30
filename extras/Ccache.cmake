find_program(CCACHE_PROGRAM ccache CMAKE_FIND_ROOT_PATH_BOTH)
if(NOT CCACHE_PROGRAM)
    message(WARNING 
        "'ccache' requested, but no installed")
    return()
endif()
message(STATUS "ccache detected: ${CCACHE_PROGRAM}")

# Set up wrapper scripts
set(CMAKE_C_COMPILER_LAUNCHER   "${CCACHE_PROGRAM}")
set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")

# Xcode generator requires special handling.
# For detailed explanation go to 
# https://crascit.com/2016/04/09/using-ccache-with-cmake/
if(CMAKE_GENERATOR STREQUAL "Xcode")
    set (LAUNCH_XCODE_C launch-c.sh)
    set (LAUNCH_XCODE_CXX launch-cxx.sh)

    execute_process(COMMAND chmod a+rx
        "${LAUNCH_XCODE_C}"
        "${LAUNCH_XCODE_CXX}"
    )

    set(CMAKE_XCODE_ATTRIBUTE_CC         "${LAUNCH_XCODE_C}")
    set(CMAKE_XCODE_ATTRIBUTE_LD         "${LAUNCH_XCODE_C}")

    set(CMAKE_XCODE_ATTRIBUTE_CXX        "${LAUNCH_XCODE_CXX}")
    set(CMAKE_XCODE_ATTRIBUTE_LDPLUSPLUS "${LAUNCH_XCODE_CXX}")
elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
        string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
        string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
    elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
        string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
        string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}")
    endif()
endif()