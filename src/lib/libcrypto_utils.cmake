set(TARGET crypto_utils_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/core/libcrypto_utils")

set(TARGET_CFLAGS
    "-Wall"
    "-Wextra"
    "-Werror"
)

set(libcrypto_utils "${TARGET_SRC_DIR}/android_pubkey.cpp")

add_library(${TARGET} STATIC ${libcrypto_utils})

target_include_directories(${TARGET}
    PUBLIC ${libcrypto_utils_headers}
    PRIVATE ${libcrypto_headers}
)

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)
