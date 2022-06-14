myRepo=$(pwd)

if [ ! -d "$myRepo/pytorch" ]; then
    echo "cloning pytorch"
    git clone --recursive --branch master https://github.com/pytorch/pytorch
fi
cd pytorch
git stash
git stash clear
git pull --rebase
git submodule update --init --recursive
cd ..
python3 -m pip uninstall torch -y
cd -
python3 setup.py install --user
cd ..

if [ ! -d "$myRepo/torchvision" ]; then
    echo "cloning torchvision"
    git clone --branch main https://github.com/pytorch/vision torchvision
fi
cd torchvision
git stash
git stash clear
git pull --rebase
git submodule update --init --recursive
cd ..
python3 -m pip uninstall torchvision -y
cd -
python3 setup.py install --user
cd ..
