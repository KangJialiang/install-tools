#!/usr/bin/env bash

myRepo=$(pwd)
#CMAKE_CONFIG_GENERATOR=("Visual Studio 16 2019" -A x64)
CMAKE_CONFIG_GENERATOR="Ninja"
RepoSource=opencv
processors=$(cat /proc/cpuinfo | grep "processor" | wc -l)

if [ ! -d "$myRepo/opencv" ]; then
    echo "cloning opencv"
    git clone https://github.com/opencv/opencv.git
else
    cd opencv
    git stash
    git stash clear
    git pull --rebase
    cd ..
fi
if [ ! -d "$myRepo/opencv_contrib" ]; then
    echo "cloning opencv_contrib"
    git clone https://github.com/opencv/opencv_contrib.git
else
    cd opencv_contrib
    git stash
    git stash clear
    git pull --rebase
    cd ..
fi
if [ ! -d "$myRepo/opencv_extra" ]; then
    echo "cloning opencv_extra"
    git clone https://github.com/opencv/opencv_extra.git
else
    cd opencv_extra
    git stash
    git stash clear
    git pull --rebase
    cd ..
fi

if [ ! -d "$myRepo/build" ]; then
    mkdir -p build/
fi

cd "$myRepo"/build
CMAKE_OPTIONS='-DBUILD_PERF_TESTS:BOOL=ON \
    -DBUILD_TESTS:BOOL=ON \
    -DBUILD_DOCS:BOOL=ON \
    -DWITH_CUDA:BOOL=ON \
    -DWITH_CUDNN:BOOL=ON \
    -DOPENCV_DNN_CUDA=ON \
    -DBUILD_EXAMPLES:BOOL=ON \
    -DBUILD_opencv_python3=OFF \
    -DBUILD_opencv_python2=OFF \
    -DOPENCV_ENABLE_NONFREE=ON \
    -DINSTALL_CREATE_DISTRIB=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DENABLE_PRECOMPILED_HEADERS=OFF' # for windows to avoid Eigen error
cmake -G"$CMAKE_CONFIG_GENERATOR" \
    -Wno-dev \
    $CMAKE_OPTIONS \
    -DOPENCV_EXTRA_MODULES_PATH="$myRepo"/opencv_contrib/modules \
    "$myRepo/$RepoSource" # -DCMAKE_INSTALL_PREFIX="$myRepo/install/$RepoSource"

echo "************************* $RepoSource -->debug"
cmake --build . --config debug --parallel $(expr 3 \* $processors / 2)
echo "************************* $RepoSource -->release"
cmake --build . --config release --parallel $(expr 3 \* $processors / 2)

export OPENCV_TEST_DATA_PATH="$myRepo"/opencv_extra/testdata/
"$myRepo"/build/bin/opencv_test_core

cmake --build . --target install --config release --parallel
cmake --build . --target install --config debug --parallel
