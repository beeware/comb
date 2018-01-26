#!/bin/bash
echo "Python version=`python --version`"
if [ "$CODE_URL" ]; then
    echo "Testing $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
    echo
    # Download and unpack code at the test SHA
    echo "curl -L $CODE_URL -o code.zip"
    curl -s -L $CODE_URL -o code.zip
    echo "--------------------------------------------------------------------------------"
    echo "unzip code.zip"
    unzip code.zip
    mv $GITHUB_PROJECT_NAME-$SHA src
else
    echo "Using local code checkout."
fi
echo "--------------------------------------------------------------------------------"
if [ "$EXTRA_REQUIRES" ]; then
    for pkg in $EXTRA_REQUIRES; do
        echo Installing extra requirement $pkg
        pip install $pkg
    done
else
    echo "No extra requirements"
fi
echo "--------------------------------------------------------------------------------"
cd src
if [ "$SRC_REQUIRES" ]; then
    for pkg_dir in $SRC_REQUIRES; do
        echo Installing requirement $pkg_dir from src
        pushd $pkg_dir
        pip install -e .
        popd
    done
else
    echo "No source requirements"
fi
echo "--------------------------------------------------------------------------------"
if [ "$TEST_DIR" ]; then
    pushd $TEST_DIR
    echo "Installing test code from $TEST_DIR"
fi
echo pip install -e .
pip install -e .
if [ "$TEST_DIR" ]; then
    popd
fi
echo "--------------------------------------------------------------------------------"
if [ "$SRC_DEPENDANTS" ]; then
    for pkg_dir in $SRC_DEPENDANTS; do
        echo "Installing dependant $pkg_dir from src"
        pushd $pkg_dir
        pip install -e .
        popd
    done
else
    echo "No source dependants"
fi
echo "================================================================================"
if [ "$TEST_DIR" ]; then
    cd $TEST_DIR
    echo "Running test code from $TEST_DIR"
fi
echo python setup.py test
python setup.py test
