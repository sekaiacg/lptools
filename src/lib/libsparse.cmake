set(TARGET sparse_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/core/libsparse")

set(TARGET_CFLAGS "-Werror")

set(libsparse_srcs
    "${TARGET_SRC_DIR}/backed_block.cpp"
    "${TARGET_SRC_DIR}/output_file.cpp"
    "${TARGET_SRC_DIR}/sparse.cpp"
    "${TARGET_SRC_DIR}/sparse_crc32.cpp"
    "${TARGET_SRC_DIR}/sparse_err.cpp"
    "${TARGET_SRC_DIR}/sparse_read.cpp"
)

add_library(${TARGET} STATIC ${libsparse_srcs})

target_include_directories(${TARGET}
    PUBLIC ${libsparse_headers}
    PRIVATE
    ${libbase_headers}
    ${libz_headers}
)
target_link_libraries(${TARGET} base_static z_static)

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
