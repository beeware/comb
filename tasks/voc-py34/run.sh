#!/bin/bash
echo "Testing $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
echo "Python version=`python --version`"
java -version
ant -version
echo
# Download and unpack code at the test SHA
echo "curl -L $CODE_URL -o code.zip"
curl -s -L $CODE_URL -o code.zip
echo "--------------------------------------------------------------------------------"
echo "unzip code.zip"
unzip code.zip
cd $GITHUB_PROJECT_NAME-$SHA
echo "--------------------------------------------------------------------------------"
echo pip install -e .
pip install -e .
echo "--------------------------------------------------------------------------------"
echo pip install pytest pytest-xdist pytest-runner
pip install pytest pytest-xdist pytest-runner
echo "--------------------------------------------------------------------------------"
# Precompile to avoid duplicated effort when pytest starts.
echo ant java
ant java
export PRECOMPILE=false
echo "================================================================================"
echo pytest -v -n auto --maxfail=20
pytest -v -n auto --maxfail=20
