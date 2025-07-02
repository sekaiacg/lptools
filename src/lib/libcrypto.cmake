set(TARGET crypto_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/boringssl")

set(TARGET_CFLAGS
    "-DBORINGSSL_IMPLEMENTATION"
    "-fvisibility=hidden"
    #"-DBORINGSSL_SHARED_LIBRARY"
    "-DBORINGSSL_ANDROID_SYSTEM"
    "-DOPENSSL_SMALL"
    #"-Werror"
    "-Wno-unused-parameter"
)

set(TARGET_LDFLAGS)

if (CMAKE_SYSTEM_NAME MATCHES "Linux")
    list(APPEND libcrypto_sources ${libcrypto_sources_asm})
    list(APPEND libcrypto_bcm_sources ${libcrypto_bcm_sources_asm})
elseif (CMAKE_SYSTEM_NAME MATCHES "Android")
    list(APPEND TARGET_LDFLAGS "-Wl,-Bsymbolic")
elseif (CMAKE_SYSTEM_NAME MATCHES "Windows")
    list(APPEND TARGET_LDFLAGS "-lws2_32")
endif ()

include(libcrypto_sources.cmake)
set(libcrypto_srcs
    ${libcrypto_sources}
    ${libcrypto_bcm_sources}
)
set(TARGET_CFLAGS ${libcrypto_sources_flags})

add_library(${TARGET} STATIC ${libcrypto_srcs})

target_include_directories(${TARGET} PUBLIC ${libcrypto_headers})

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)

target_link_options(${TARGET} PRIVATE
    "$<$<LINK_LANGUAGE:C>:${TARGET_LDFLAGS}>"
    "$<$<LINK_LANGUAGE:CXX>:${TARGET_LDFLAGS}>"
    "$<$<LINK_LANGUAGE:ASM>:${TARGET_LDFLAGS}>"
)