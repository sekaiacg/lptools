set(TARGET jsonpbparse_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/extras/libjsonpb/parse")

set(TARGET_CFLAGS
    "-Wall"
    "-Werror"
    "-Wno-unused-parameter"
)

set(libjsonpbparse_srcs "${TARGET_SRC_DIR}/jsonpb.cpp")

add_library(${TARGET} STATIC ${libjsonpbparse_srcs})

target_include_directories(${TARGET}
    PUBLIC ${libjsonpbparse_headers}
    PRIVATE
    ${libbase_headers}
    ${libprotobuf-cpp-full_headers}
)

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
