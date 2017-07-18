#!/bin/bash
echo "Waggling $GITHUB_OWNER/$GITHUB_PROJECT_NAME @ $SHA"
echo "Python version=`python --version`"
echo
# Download and unpack code at the test SHA
curl -s -L -u $GITHUB_USERNAME:$GITHUB_ACCESS_TOKEN https://github.com/$GITHUB_OWNER/$GITHUB_PROJECT_NAME/archive/$SHA.zip -o code.zip
unzip code.zip

cd $GITHUB_PROJECT_NAME-$SHA
echo "--------------------------------------------------------------------------------"
echo pip install waggle
pip install waggle
echo "================================================================================"
echo python waggler.py $GITHUB_PROJECT_NAME-$SHA
python waggler.py $GITHUB_PROJECT_NAME-$SHA
