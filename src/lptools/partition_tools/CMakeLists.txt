set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}")

set(TARGET_CFLAGS
    "-Werror"
    "-Wextra"
    "-D_FILE_OFFSET_BITS=64"
)

set(common_headers
    ${libbase_headers}
    ${liblog_headers}
    ${liblp_headers}
    ${libsparse_headers}
)

set(common_static_lib base_static log_static lp_static)

if (CMAKE_SYSTEM_NAME MATCHES "Windows")
    list(APPEND common_static_lib pthread)
endif ()

###############################------lpadd------###############################
set(TARGET_lpadd lpadd)
set(lpadd_srcs "${TARGET_SRC_DIR}/lpadd.cc")
add_executable(${TARGET_lpadd} ${lpadd_srcs})
target_include_directories(${TARGET_lpadd} PRIVATE ${common_headers})
target_link_libraries(${TARGET_lpadd} PRIVATE ${common_static_lib})
target_compile_options(${TARGET_lpadd} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
##################################################################################

###############################------lpdump------###############################
set(TARGET_lpdump lpdump)
set(lpdump_srcs
    "${TARGET_SRC_DIR}/lpdump_host.cc"
    "${TARGET_SRC_DIR}/lpdump.cc"
    "${TARGET_SRC_DIR}/dynamic_partitions_device_info.pb.cc"
)
add_executable(${TARGET_lpdump} ${lpdump_srcs})
target_include_directories(${TARGET_lpdump} PRIVATE
    ${common_headers}
    ${libjsonpbparse_headers}
    ${libprotobuf-cpp-full_headers}
)
target_link_libraries(${TARGET_lpdump} ${common_static_lib} jsonpbparse_static protobuf-cpp-full)
target_compile_options(${TARGET_lpdump} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
##################################################################################

###############################------lpflash------###############################
if (CMAKE_SYSTEM_NAME MATCHES "Linux|Android")
    set(TARGET_lpflash lpflash)
    set(lpflash_srcs "${TARGET_SRC_DIR}/lpflash.cc")
    add_executable(${TARGET_lpflash} ${lpflash_srcs})
    target_include_directories(${TARGET_lpflash} PRIVATE ${common_headers})
    target_link_libraries(${TARGET_lpflash} ${common_static_lib})
    target_link_options(${TARGET_lpflash} PRIVATE "$<$<LINK_LANGUAGE:C>:-fuse-ld=lld>" "$<$<LINK_LANGUAGE:CXX>:-fuse-ld=lld>")
    target_compile_options(${TARGET_lpflash} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
endif ()
##################################################################################

###############################------lpmake------###############################
set(TARGET_lpmake lpmake)
set(lpmake_srcs "${TARGET_SRC_DIR}/lpmake.cc")
add_executable(${TARGET_lpmake} ${lpmake_srcs})
target_include_directories(${TARGET_lpmake} PRIVATE
    ${libbase_headers}
    ${liblog_headers}
    ${liblp_headers}
    ${libfmtlib_headers}
)
target_link_libraries(${TARGET_lpmake} ${common_static_lib})
target_compile_options(${TARGET_lpmake} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
##################################################################################

###############################------lpunpack------###############################
set(TARGET_lpunpack lpunpack)
set(lpunpack_srcs "${TARGET_SRC_DIR}/lpunpack.cc")
add_executable(${TARGET_lpunpack} ${lpunpack_srcs})
target_include_directories(${TARGET_lpunpack} PRIVATE ${common_headers})
target_link_libraries(${TARGET_lpunpack} ${common_static_lib} sparse_static)
target_compile_options(${TARGET_lpunpack} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
##################################################################################
