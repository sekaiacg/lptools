set(TARGET_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../lib/core/libsparse")

set(TARGET_CFLAGS
    "-Werror"
    "-D_FILE_OFFSET_BITS=64"
)

set(common_static_lib base_static z_static sparse_static)

###############################------img2simg------###############################
set(TARGET_img2simg img2simg)
set(img2simg_srcs "${TARGET_SRC_DIR}/img2simg.cpp")
add_executable(${TARGET_img2simg} ${img2simg_srcs})
target_include_directories(${TARGET_img2simg} PRIVATE ${libsparse_headers})
target_link_libraries(${TARGET_img2simg} ${common_static_lib})
target_compile_options(${TARGET_img2simg} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
##################################################################################

###############################------simg2img------###############################
set(TARGET_simg2img simg2img)
set(simg2img_srcs
    "${TARGET_SRC_DIR}/simg2img.cpp"
    "${TARGET_SRC_DIR}/sparse_crc32.cpp"
)
add_executable(${TARGET_simg2img} ${simg2img_srcs})
target_include_directories(${TARGET_simg2img} PRIVATE ${libsparse_headers})
target_link_libraries(${TARGET_simg2img} ${common_static_lib})
target_compile_options(${TARGET_simg2img} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
###################################################################################

###############################------append2simg------#############################
set(TARGET_append2simg append2simg)
set(append2simg_srcs "${TARGET_SRC_DIR}/append2simg.cpp")
add_executable(${TARGET_append2simg} ${append2simg_srcs})
target_include_directories(${TARGET_append2simg} PRIVATE ${libsparse_headers})
target_link_libraries(${TARGET_append2simg} ${common_static_lib})
target_compile_options(${TARGET_append2simg} PRIVATE "$<$<COMPILE_LANGUAGE:C>:${TARGET_CFLAGS}>" "$<$<COMPILE_LANGUAGE:CXX>:${TARGET_CFLAGS}>")
###################################################################################
