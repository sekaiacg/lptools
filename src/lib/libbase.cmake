set(TARGET base_static)

set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/libbase")

set(TARGET_CFLAGS
    "-Wall"
    "-Werror"
    "-Wextra"
    "-D_FILE_OFFSET_BITS=64"
    "-Wexit-time-destructors"
    "-Wno-c99-designator"
)

check_compile_flag_supported("-Wno-vla-cxx-extension" IF_SUPPORT)
if (IF_SUPPORT)
    list(APPEND TARGET_CFLAGS "-Wno-vla-cxx-extension")
else ()
    list(APPEND TARGET_CFLAGS "-Wno-vla-extension")
endif ()

set(libbase_srcs
    "${TARGET_SRC_DIR}/abi_compatibility.cpp"
    "${TARGET_SRC_DIR}/chrono_utils.cpp"
    "${TARGET_SRC_DIR}/cmsg.cpp"
    "${TARGET_SRC_DIR}/file.cpp"
    "${TARGET_SRC_DIR}/hex.cpp"
    "${TARGET_SRC_DIR}/logging.cpp"
    "${TARGET_SRC_DIR}/mapped_file.cpp"
    "${TARGET_SRC_DIR}/parsebool.cpp"
    "${TARGET_SRC_DIR}/parsenetaddress.cpp"
    "${TARGET_SRC_DIR}/posix_strerror_r.cpp"
    "${TARGET_SRC_DIR}/process.cpp"
    "${TARGET_SRC_DIR}/properties.cpp"
    "${TARGET_SRC_DIR}/result.cpp"
    "${TARGET_SRC_DIR}/stringprintf.cpp"
    "${TARGET_SRC_DIR}/strings.cpp"
    "${TARGET_SRC_DIR}/threads.cpp"
    "${TARGET_SRC_DIR}/test_utils.cpp"
)

if (CMAKE_SYSTEM_NAME MATCHES "Android")
    list(APPEND TARGET_CFLAGS "-D_FILE_OFFSET_BITS=64")
elseif (CMAKE_SYSTEM_NAME MATCHES "Linux|Darwin")
    list(APPEND libbase_srcs "${TARGET_SRC_DIR}/errors_unix.cpp")
elseif (CMAKE_SYSTEM_NAME MATCHES "Windows")
    list(APPEND libbase_srcs
        "${TARGET_SRC_DIR}/errors_windows.cpp"
        "${TARGET_SRC_DIR}/utf8.cpp"
    )
    list(REMOVE_ITEM libbase_srcs "${TARGET_SRC_DIR}/cmsg.cpp")
    list(APPEND TARGET_CFLAGS "-D_POSIX_THREAD_SAFE_FUNCTIONS")
endif ()

add_library(${TARGET} STATIC ${libbase_srcs})

target_include_directories(${TARGET}
    PUBLIC ${libbase_headers}
    PRIVATE ${liblog_headers}
)

target_link_libraries(${TARGET} fmtlib_static)

target_compile_options(${TARGET} PRIVATE
    "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>"
)