#!/bin/bash
echo "Testing $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
echo "Python version=`python --version`"
echo "Node version=`node --version`"
echo "NPM version=`npm --version`"
echo
# Make sure we're using the right npm
export PATH=/app/node_modules/.bin:$PATH

# Download and unpack code at the test SHA
curl -s -L -u $GITHUB_USERNAME:$GITHUB_ACCESS_TOKEN https://github.com/$GITHUB_OWNER/$GITHUB_PROJECT_NAME/archive/$SHA.zip -o code.zip
unzip code.zip

cd $GITHUB_PROJECT_NAME-$SHA
echo "--------------------------------------------------------------------------------"
echo pip install -e .
pip install -e .
echo "--------------------------------------------------------------------------------"
echo pip install pytest pytest-xdist pytest-runner
pip install pytest pytest-xdist pytest-runner
echo "--------------------------------------------------------------------------------"
echo npm install --unsafe-perm
npm install --unsafe-perm
echo "--------------------------------------------------------------------------------"
# Precompile to avoid duplicated effort when pytest starts.
echo ./node_modules/.bin/webpack --progress
./node_modules/.bin/webpack --progress
export PRECOMPILE=false
echo "================================================================================"
echo pytest -n auto --ignore node_modules
pytest -n auto --ignore node_modules
