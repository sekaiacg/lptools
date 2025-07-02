set(TARGET lp_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/core/fs_mgr/liblp")

set(TARGET_CFLAGS
    "-Wall"
    "-Werror"
    "-D_FILE_OFFSET_BITS=64"
)

check_compile_flag_supported("-Wno-vla-cxx-extension" IF_SUPPORT)
if (IF_SUPPORT)
    list(APPEND TARGET_CFLAGS "-Wno-vla-cxx-extension")
else ()
    list(APPEND TARGET_CFLAGS "-Wno-vla-extension")
endif ()

set(liblp_srcs
    "${TARGET_SRC_DIR}/builder.cpp"
    "${TARGET_SRC_DIR}/super_layout_builder.cpp"
    "${TARGET_SRC_DIR}/images.cpp"
    "${TARGET_SRC_DIR}/partition_opener.cpp"
    "${TARGET_SRC_DIR}/property_fetcher.cpp"
    "${TARGET_SRC_DIR}/reader.cpp"
    "${TARGET_SRC_DIR}/utility.cpp"
    "${TARGET_SRC_DIR}/writer.cpp"
)

add_library(${TARGET} STATIC ${liblp_srcs})

target_include_directories(${TARGET}
    PUBLIC ${liblp_headers}
    PRIVATE
    ${libbase_headers}
    ${libcutils_headers}
    ${libsparse_headers}
    ${libext4_utils_headers}
    ${libcrypto_headers}
)
set(common_libs
    z_static
    base_static
    log_static
    crypto_static
    crypto_utils_static
    sparse_static
    ext4_utils_static
)

target_link_libraries(${TARGET} PRIVATE ${common_libs})

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
