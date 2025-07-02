set(TARGET ext4_utils_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/extras/ext4_utils")

set(TARGET_CFLAGS
    "-Werror"
    "-fno-strict-aliasing"
    "-D_FILE_OFFSET_BITS=64"
)

set(TARGET_LDFLAGS)

set(libext4_utils_srcs
    "${TARGET_SRC_DIR}/ext4_utils.cpp"
    "${TARGET_SRC_DIR}/wipe.cpp"
    "${TARGET_SRC_DIR}/ext4_sb.cpp"
)

if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
    list(APPEND TARGET_CFLAGS "-Wno-vla-cxx-extension")
    list(APPEND TARGET_LDFLAGS "-lws2_32")
endif ()

add_library(${TARGET} STATIC ${libext4_utils_srcs})

target_include_directories(${TARGET}
    PUBLIC ${libext4_utils_headers}
    PRIVATE ${libbase_headers}
)

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)

target_link_options(${TARGET} PRIVATE
    "$<$<LINK_LANGUAGE:C>:${TARGET_LDFLAGS}>"
    "$<$<LINK_LANGUAGE:CXX>:${TARGET_LDFLAGS}>"
    "$<$<LINK_LANGUAGE:ASM>:${TARGET_LDFLAGS}>"
)
