#!/bin/bash
echo "Python version=`python --version`"
echo "Node version=`node --version`"
echo "NPM version=`npm --version`"
echo
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
echo pip install -e .
pip install -e .
echo "--------------------------------------------------------------------------------"
echo npm install --unsafe-perm --no-color
npm install --unsafe-perm --no-color
echo "--------------------------------------------------------------------------------"
# Precompile to avoid duplicated effort when pytest starts.
echo ./node_modules/.bin/webpack --progress
./node_modules/.bin/webpack --progress
export PRECOMPILE=false
echo "================================================================================"
echo pytest -v -n auto --maxfail=20 --ignore node_modules
pytest -v -n auto --maxfail=20 --ignore node_modules
