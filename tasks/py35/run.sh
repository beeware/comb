#!/bin/bash
echo "Testing $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
echo "Python version=`python --version`"
echo
# Download and unpack code at the test SHA
echo "curl -L $CODE_URL -o code.zip"
curl -s -L $CODE_URL -o code.zip
echo "--------------------------------------------------------------------------------"
echo "unzip code.zip"
unzip code.zip

cd $GITHUB_PROJECT_NAME-$SHA
if [ -e "$TEST_DIR" ]; then
    cd $TEST_DIR
fi
echo "--------------------------------------------------------------------------------"
for pkg_dir in $SRC_REQUIRES; do
    echo Installing $pkg_dir from src
    pushd $pkg_dir
    pip install -e .
    popd
done
echo "--------------------------------------------------------------------------------"
echo pip install -e .
pip install -e .
echo "================================================================================"
echo python setup.py test
python setup.py test
