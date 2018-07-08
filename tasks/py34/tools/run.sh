#!/bin/bash
echo "Python version=`python --version`"
if [ -e "/app/beekeeper.yml" ]; then
    echo "Testing local code"
else
    echo "Testing $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
    echo
    # Download and unpack code at the test SHA
    echo "curl -L $CODE_URL -o code.zip"
    curl -s -L $CODE_URL -o code.zip
    echo "--------------------------------------------------------------------------------"
    echo "unzip code.zip"
    unzip code.zip
    cd $GITHUB_PROJECT_NAME-$SHA
fi
echo "--------------------------------------------------------------------------------"
if [ "$EXTRA_REQUIRES" ]; then
    for pkg in $EXTRA_REQUIRES; do
        echo Installing extra requirement $pkg
        pip install $pkg
    done
else
    echo No extra requirements to install
fi
echo "--------------------------------------------------------------------------------"
if [ "$SRC_REQUIRES" ]; then
    for pkg_dir in $SRC_REQUIRES; do
        echo Installing requirement $pkg_dir from src
        pip install -e $pkg_dir
    done
else
    echo No source requirements to install.
fi
echo "--------------------------------------------------------------------------------"
if [ "$TEST_DIR" ]; then
    echo Installing test code from $TEST_DIR
    echo pip install -e $TEST_DIR
    pip install -e $TEST_DIR
else
    echo Installing test code from project root
    echo pip install -e .
    pip install -e .
fi
echo "--------------------------------------------------------------------------------"
if [ "$SRC_DEPENDANTS" ]; then
    for pkg_dir in $SRC_DEPENDANTS; do
        echo Installing dependant $pkg_dir from src
        pip install -e $pkg_dir
    done
else
    echo No source dependencies to install.
fi
echo "================================================================================"
if [ "$TEST_DIR" ]; then
    cd $TEST_DIR
    echo Running test code from $TEST_DIR
else
    echo Running test code from project root
fi
echo python setup.py test
python setup.py test
