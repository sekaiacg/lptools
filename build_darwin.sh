OUT="./out"
BUILD_DIR="./"

cmake_build()
{
    local TARGET=$1
    local METHOD=$2
    local ABI=$3

    local MAKE_CMD=""
    local BUILD_METHOD=""
    if [[ $METHOD == "Ninja" ]]; then
        BUILD_METHOD="-G Ninja"
        MAKE_CMD="time -p cmake --build $OUT -j$(sysctl -n hw.logicalcpu) --target lpadd lpdump lpmake lpunpack append2simg img2simg simg2img"
    elif [[ $METHOD == "make" ]]; then
        MAKE_CMD="time -p make -C $OUT -j$(sysctl -n hw.logicalcpu)"
    fi

    local PROCESSOR=""
    [ ${ABI} == "x86_64" ] && PROCESSOR="x86_64"
    [ ${ABI} == "aarch64" ] && PROCESSOR="arm64"

    if [[ $TARGET == "Darwin" ]]; then
        cmake -S ${BUILD_DIR} -B ${OUT} ${BUILD_METHOD} \
            -DPAYLOAD_EXTRACT_VERSION="${VERSION}" \
            -DCMAKE_SYSTEM_NAME="Darwin" \
            -DCMAKE_SYSTEM_PROCESSOR="${PROCESSOR}" \
            -DCMAKE_BUILD_TYPE="Release" \
            -DCMAKE_C_COMPILER_TARGET="${ABI}-apple-darwin" \
            -DCMAKE_CXX_COMPILER_TARGET="${ABI}-apple-darwin" \
            -DCMAKE_OSX_DEPLOYMENT_TARGET="10.15" \
            -DCMAKE_C_COMPILER_LAUNCHER="ccache" \
            -DCMAKE_CXX_COMPILER_LAUNCHER="ccache" \
            -DCMAKE_C_COMPILER="clang" \
            -DCMAKE_CXX_COMPILER="clang++" \
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
    local METHOD=""
    if [[ -f $NINJA ]]; then
        METHOD="Ninja"
    else
        METHOD="make"
    fi

    cmake_build "${TARGET}" "${METHOD}" "${ABI}" "${PLATFORM}"

    local P_BIN_DIR="${OUT}/src/lptools/partition_tools"
    local LPADD_BIN="$P_BIN_DIR/lpadd"
    local LPDUMP_BIN="$P_BIN_DIR/lpdump"
    local LPMAKE_BIN="$P_BIN_DIR/lpmake"
    local LPUNPACK_BIN="$P_BIN_DIR/lpunpack"

    local S_BIN_DIR="${OUT}/src/lptools/sparse_tools"
    local APPEND2SIMG_BIN="$S_BIN_DIR/append2simg"
    local IMG2SIMG_BIN="$S_BIN_DIR/img2simg"
    local SIMG2IMG_BIN="$S_BIN_DIR/simg2img"

    local TARGE_DIR_NAME="lptools-$(TZ=UTC-8 date +%y%m%d)-${TARGET}_${ABI}"
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

build "Darwin" "x86_64"
build "Darwin" "aarch64"

exit 0
