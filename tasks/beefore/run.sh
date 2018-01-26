#!/bin/bash
echo "Running Beefore $TASK task on $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
echo "Python version=`python --version`"
echo "Node version=`node --version`"
echo "NPM version=`npm --version`"
echo
# Download and unpack code at the test SHA
echo "--------------------------------------------------------------------------------"
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
echo pip install beefore
pip install beefore
# Run checks
echo "================================================================================"
echo beefore
echo "    --username $GITHUB_USERNAME"
echo "    --repository $GITHUB_OWNER/$GITHUB_PROJECT_NAME"
echo "    --pull-request $GITHUB_PR_NUMBER"
echo "    --commit $SHA"
echo "    $TASK src"

beefore --username $GITHUB_USERNAME \
    --repository $GITHUB_OWNER/$GITHUB_PROJECT_NAME \
    --pull-request $GITHUB_PR_NUMBER \
    --commit $SHA \
    $TASK src
