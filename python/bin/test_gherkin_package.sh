#!/bin/bash

#####################################################################
#
# This script will run unit tests
#
#   Parameters:
#       -f=*|--folder=*     -> folder name in which the python libraries can be found (discovered from root folder by Jenkinsfile)
#
#####################################################################

set -eu
[ -e /etc/televic/debug ] && set -x

FOLDER=""

unit_test_package()
{
    echo "----- Run unit test for $FOLDER -----"

    echo "----- Add /home/jenkins/.local/bin to PATH -----"
    PATH=${PATH}:/home/jenkins/.local/bin

    echo "----- Install ../requirements.txt ------"
    python3 -m pip install -r ../requirements.txt

    echo "----- List tox test environments ------"
    tox -l

    echo "----- Run tox with python3 -----"
    python3 -m tox -vv
}


for i in "$@"
do
case $i in
    -f=*|--folder=*)
    FOLDER="${i#*=}"
    shift  # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done

echo "----- Testing in folder ${FOLDER} ------"

cd $FOLDER
unit_test_package
