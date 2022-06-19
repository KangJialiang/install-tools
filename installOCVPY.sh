
myRepo=$(pwd)

if [ ! -d "$myRepo/opencv-python" ]; then
    echo "cloning opencv-python"
    git clone --recursive https://github.com/opencv/opencv-python.git
fi
cd opencv-python
git stash
git stash clear
git pull --rebase
git submodule update --init --recursive
export ENABLE_CONTRIB=1
export ENABLE_HEADLESS=0
export CMAKE_ARGS="-DOPENCV_ENABLE_NONFREE=ON"
pip3 wheel . --verbose
