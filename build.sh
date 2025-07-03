OUT="./out"
BUILD_DIR="./"

cmake_build()
{
    local TARGET=$1
    local METHOD=$2
    local ABI=$3

    if [[ $METHOD == "Ninja" ]]; then
        local BUILD_METHOD="-G Ninja"
        local MAKE_CMD="time -p cmake --build $OUT -j$(nproc) --target lpadd lpdump lpmake lpunpack append2simg img2simg simg2img"
    elif [[ $METHOD == "make" ]]; then
        local MAKE_CMD="time -p make -C $OUT -j$(nproc)"
    fi;

    if [[ $TARGET == "Android" ]]; then
        local ANDROID_PLATFORM=$4
        cmake -S ${BUILD_DIR} -B $OUT ${BUILD_METHOD} \
            -DNDK_CCACHE="ccache" \
            -DCMAKE_BUILD_TYPE="Release" \
            -DANDROID_PLATFORM="$ANDROID_PLATFORM" \
            -DANDROID_ABI="$ABI" \
            -DANDROID_STL="none" \
            -DCMAKE_TOOLCHAIN_FILE="$ANDROID_NDK_LATEST_HOME/build/cmake/android.toolchain.cmake" \
            -DANDROID_USE_LEGACY_TOOLCHAIN_FILE="OFF" \
            -DCMAKE_C_FLAGS="" \
            -DCMAKE_CXX_FLAGS="" \
            -DENABLE_FULL_LTO="ON"
    elif [[ $TARGET == "Linux" ]]; then
        local LINUX_PLATFORM=$4
        if [[ ${ABI} == "x86_64" ]]; then
            cmake -S ${BUILD_DIR} -B ${OUT} ${BUILD_METHOD} \
                -DCMAKE_SYSTEM_NAME="Linux" \
                -DCMAKE_SYSTEM_PROCESSOR="x86_64" \
                -DCMAKE_BUILD_TYPE="Release" \
                -DCMAKE_C_COMPILER_LAUNCHER="ccache" \
                -DCMAKE_CXX_COMPILER_LAUNCHER="ccache" \
                -DCMAKE_C_COMPILER="clang" \
                -DCMAKE_CXX_COMPILER="clang++" \
                -DCMAKE_C_FLAGS="" \
                -DCMAKE_CXX_FLAGS="" \
                -DENABLE_FULL_LTO="ON"
        elif [[ ${ABI} == "aarch64" ]]; then
            cmake -S ${BUILD_DIR} -B ${OUT} ${BUILD_METHOD} \
                -DCMAKE_SYSTEM_NAME="Linux" \
                -DCMAKE_SYSTEM_PROCESSOR="aarch64" \
                -DCMAKE_BUILD_TYPE="Release" \
                -DCMAKE_C_COMPILER_LAUNCHER="ccache" \
                -DCMAKE_CXX_COMPILER_LAUNCHER="ccache" \
                -DCMAKE_C_COMPILER="${CUSTOM_CLANG_PATH}/bin/clang" \
                -DCMAKE_CXX_COMPILER="${CUSTOM_CLANG_PATH}/bin/clang++" \
                -DCMAKE_SYSROOT="${GCC_AARCH64_TOOLS_PATH}/aarch64-linux-gnu/libc" \
                -DCMAKE_C_COMPILER_TARGET="aarch64-linux-gnu" \
                -DCMAKE_CXX_COMPILER_TARGET="aarch64-linux-gnu" \
                -DCMAKE_ASM_COMPILER_TARGET="aarch64-linux-gnu" \
                -DCMAKE_C_FLAGS="--gcc-toolchain=${GCC_AARCH64_TOOLS_PATH}" \
                -DCMAKE_CXX_FLAGS="--gcc-toolchain=${GCC_AARCH64_TOOLS_PATH}" \
                -DENABLE_FULL_LTO="ON"
        fi
    elif [[ $TARGET == "Windows" ]]; then
        cmake -S ${BUILD_DIR} -B ${OUT} ${BUILD_METHOD} \
            -DCMAKE_BUILD_TYPE="Release" \
            -DMINGW_ABI="$ABI" \
            -DMINGW_SYSROOT="${LLVM_MINGW_PATH}" \
            -DCMAKE_TOOLCHAIN_FILE="$(pwd)/cmake/llvm-mingw.cmake" \
            -DCMAKE_C_COMPILER_LAUNCHER="ccache" \
            -DCMAKE_CXX_COMPILER_LAUNCHER="ccache" \
            -DCMAKE_C_FLAGS="" \
            -DCMAKE_CXX_FLAGS="" \
            -DENABLE_FULL_LTO="ON"
    fi

    ${MAKE_CMD}
}

build()
{
    local TARGET=$1
    local ABI=$2
    local PLATFORM=$3

    rm -rf $OUT > /dev/null 2>&1

    local NINJA=`which ninja`
    if [[ -f $NINJA ]]; then
        local METHOD="Ninja"
    else
        local METHOD="make"
    fi

    cmake_build "${TARGET}" "${METHOD}" "${ABI}" "${PLATFORM}"
    local BIN_SUFFIX=""
    [ "${TARGET}" == "Windows" ] && BIN_SUFFIX=".exe"

    local P_BIN_DIR="${OUT}/src/lptools/partition_tools"
    local LPADD_BIN="$P_BIN_DIR/lpadd${BIN_SUFFIX}"
    local LPDUMP_BIN="$P_BIN_DIR/lpdump${BIN_SUFFIX}"
    local LPMAKE_BIN="$P_BIN_DIR/lpmake${BIN_SUFFIX}"
    local LPUNPACK_BIN="$P_BIN_DIR/lpunpack${BIN_SUFFIX}"

    local S_BIN_DIR="${OUT}/src/lptools/sparse_tools"
    local APPEND2SIMG_BIN="$S_BIN_DIR/append2simg${BIN_SUFFIX}"
    local IMG2SIMG_BIN="$S_BIN_DIR/img2simg${BIN_SUFFIX}"
    local SIMG2IMG_BIN="$S_BIN_DIR/simg2img${BIN_SUFFIX}"

    local TARGE_DIR_NAME="lptools-${TARGET}_${ABI}-$(TZ=UTC-8 date +%y%m%d%H%M)"
    local TARGET_DIR_PATH="./target/${TARGET}_${ABI}/${TARGE_DIR_NAME}"

    if [ -f "$LPADD_BIN" -a -f "$LPDUMP_BIN" -a -f "$LPMAKE_BIN" -a -f "$LPUNPACK_BIN" -a -f "$APPEND2SIMG_BIN" -a -f "$IMG2SIMG_BIN" -a -f "$SIMG2IMG_BIN" ]; then
        echo "复制文件中..."
    	[[ ! -d "$TARGET_DIR_PATH" ]] && mkdir -p ${TARGET_DIR_PATH}
        cp -af $LPADD_BIN ${TARGET_DIR_PATH}
        cp -af $LPDUMP_BIN ${TARGET_DIR_PATH}
        cp -af $LPMAKE_BIN ${TARGET_DIR_PATH}
        cp -af $LPUNPACK_BIN ${TARGET_DIR_PATH}
        cp -af $APPEND2SIMG_BIN ${TARGET_DIR_PATH}
        cp -af $APPEND2SIMG_BIN ${TARGET_DIR_PATH}
        cp -af $SIMG2IMG_BIN ${TARGET_DIR_PATH}
        touch -c -d "2009-01-01 00:00:00" ${TARGET_DIR_PATH}/*
        echo "编译成功: ${TARGE_DIR_NAME}"
    else
        echo "error"
        exit 1
    fi
}

build_android()
{
    build "Android" "arm64-v8a" "android-31"
    build "Android" "armeabi-v7a" "android-31"
    build "Android" "x86_64" "android-31"
    build "Android" "x86" "android-31"
}

build_linux()
{
    build "Linux" "x86_64"
    build "Linux" "aarch64"
}

build_windows()
{
    build "Windows" "x86_64"
    build "Windows" "aarch64"
}

# build
if [[ "$1" == "Android" ]]; then
    build_android
elif [[ "$1" == "Linux" ]]; then
    build_linux
    build_windows
else
    exit 1
fi

exit 0
