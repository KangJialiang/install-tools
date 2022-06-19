#!/usr/bin/env bash

myRepo=$(pwd)

if [ ! -d "$myRepo/opencv-python" ]; then
    echo "cloning opencv-python"
    git clone --recursive https://github.com/opencv/opencv-python.git
fi
cd opencv-python
git stash
git stash clear
git pull --rebase
git submodule sync
git submodule update --init --recursive --jobs 0
git clean -f
export ENABLE_CONTRIB=1
export ENABLE_HEADLESS=0
export CMAKE_ARGS="-DOPENCV_ENABLE_NONFREE=ON"
python3 -m pip wheel . --verbose
python3 -m pip uninstall opencv* -y
find . -name "opencv*.whl" | xargs python3 -m pip install --user
