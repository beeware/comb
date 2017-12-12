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

echo "--------------------------------------------------------------------------------"
for pkg in $EXTRA_REQUIRES; do
    echo Installing extra requirement $pkg
    pip install $pkg
done
echo "--------------------------------------------------------------------------------"
cd $GITHUB_PROJECT_NAME-$SHA
for pkg_dir in $SRC_REQUIRES; do
    echo Installing requirement $pkg_dir from src
    pushd $pkg_dir
    pip install -e .
    popd
done
echo "--------------------------------------------------------------------------------"
if [ "$TEST_DIR" ]; then
    pushd $TEST_DIR
    echo Installing test code from $TEST_DIR
fi
echo pip install -e .
pip install -e .
if [ "$TEST_DIR" ]; then
    popd
fi
echo "--------------------------------------------------------------------------------"
for pkg_dir in $SRC_DEPENDANTS; do
    echo Installing dependant $pkg_dir from src
    pushd $pkg_dir
    pip install -e .
    popd
done
echo "================================================================================"
if [ "$TEST_DIR" ]; then
    cd $TEST_DIR
    echo Running test code from $TEST_DIR
fi
echo python setup.py test
python setup.py test
