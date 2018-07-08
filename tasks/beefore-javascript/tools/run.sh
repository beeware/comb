#!/bin/bash
echo "Python version=`python --version`"
echo
if [ -e "/app/beekeeper.yml" ]; then
    echo "Running Beefore $TASK task locally"
else
    echo "Running Beefore $TASK task on $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
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
echo pip install beefore
pip install beefore
# Run checks
echo "================================================================================"
echo beefore
echo "    --username $GITHUB_USERNAME"
echo "    --repository $GITHUB_OWNER/$GITHUB_PROJECT_NAME"
echo "    --pull-request $GITHUB_PR_NUMBER"
echo "    --commit $SHA"
echo "    $TASK $GITHUB_PROJECT_NAME-$SHA"

beefore --username $GITHUB_USERNAME \
    --repository $GITHUB_OWNER/$GITHUB_PROJECT_NAME \
    --pull-request $GITHUB_PR_NUMBER \
    --commit $SHA \
    $TASK .
