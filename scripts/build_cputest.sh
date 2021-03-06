#!/bin/bash

set -x

mkdir build_cputest
cd build_cputest

case ${TRAVIS_OS_NAME} in
linux)
    cmake -DBUILD_TESTS=ON -DUSE_CUDA=OFF ..
    ;;
osx)
    brew install cmake libomp
    cmake \
    -DUSE_CUDA=OFF \
    \
    -DOpenMP_C_FLAGS="-Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include" \
    -DOpenMP_C_LIB_NAMES=omp \
    -DOpenMP_CXX_FLAGS="-Xpreprocessor -fopenmp -I/usr/local/opt/libomp/include" \
    -DOpenMP_CXX_LIB_NAMES=omp \
    -DOpenMP_omp_LIBRARY=/usr/local/opt/libomp/lib/libomp.dylib \
    -DBUILD_TESTS=ON \
    ..
   ;;
windows)
    export PATH=${MSBUILD_PATH}:$PATH
    cmake -DBUILD_SHARED_LIBS=TRUE -DUSE_CUDA=OFF -DBUILD_TESTS=ON -G "Visual Studio 14 2015 Win64" ..
    ;;
esac

cmake --build . --target runtest
