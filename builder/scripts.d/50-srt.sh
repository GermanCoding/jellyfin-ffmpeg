#!/bin/bash

SCRIPT_REPO="https://github.com/Haivision/srt.git"
SCRIPT_COMMIT="b010763bdb6f5dc8c7c43ed34440465be9c735cf"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" srt
    cd srt

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" \
        -DENABLE_SHARED=OFF -DENABLE_STATIC=ON -DENABLE_CXX_DEPS=ON -DUSE_STATIC_LIBSTDCXX=ON -DENABLE_ENCRYPTION=ON -DENABLE_APPS=OFF ..
    make -j$(nproc)
    make install

    echo "Libs.private: -lstdc++" >> "$FFBUILD_PREFIX"/lib/pkgconfig/srt.pc
}

ffbuild_configure() {
    echo --enable-libsrt
}

ffbuild_unconfigure() {
    echo --disable-libsrt
}
