set(TARGET fmtlib_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/fmtlib")

set(TARGET_CFLAGS
    "-fno-exceptions"
    "-UNDEBUG"
)

set(libfmtlib_srcs "${TARGET_SRC_DIR}/src/format.cc")

add_library(${TARGET} STATIC ${libfmtlib_srcs})
target_include_directories(${TARGET} PUBLIC "${TARGET_SRC_DIR}/include")

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
