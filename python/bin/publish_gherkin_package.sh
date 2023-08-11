#!/bin/bash

#####################################################################
#
# This script will build and publish package
#
#   Parameters:
#       -f=*|--folder=*     -> folder name in which the python libraries can be found (discovered from root folder by JenkinsfilePython)
#
#####################################################################

set -eu
[ -e /etc/televic/debug ] && set -x

buildpackage()
{
    echo "----- Install ../requirements.txt ------"
    python3 -m pip install -r requirements.txt

    echo "----- Building with setup.py ------"
    python3 setup.py bdist_wheel --dist-dir="."
}

publishpackage()
{
    echo "----- Publishing with twine ------"
    python3 -m pip install --upgrade twine
    twine upload -u "$USR" -p "$PASSW" --repository-url https://nexus.televic.com/repository/TRA_pypi_hosted/ *.whl
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

echo "----- Building in folder ${FOLDER} ------"

cd $FOLDER
buildpackage
publishpackage
