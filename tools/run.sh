#!/bin/bash
echo "Python version=`python --version`"
echo "Beefore version=`beefore --version`"
echo
if [ -e "/app/beekeeper.yml" ]; then
    echo "Running Beefore Javascript $TASK task locally"
    ARGS=""
else
    echo "Running Beefore Javascript $TASK task on $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
    echo
    # Download and unpack code at the test SHA
    echo "curl -L $CODE_URL -o code.zip"
    curl -s -L $CODE_URL -o code.zip
    echo "--------------------------------------------------------------------------------"
    echo "unzip code.zip"
    unzip code.zip
    cd $GITHUB_PROJECT_NAME-$SHA

    ARGS="--username $GITHUB_USERNAME --repository $GITHUB_OWNER/$GITHUB_PROJECT_NAME --pull-request $GITHUB_PR_NUMBER --commit $SHA"
fi
# Run checks
echo "================================================================================"
echo "beefore $ARGS $TASK ."

beefore $ARGS $TASK .
