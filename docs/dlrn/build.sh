#!/usr/bin/env bash

set -x

DLRN_PATH=/home/dlrn/DLRN

printHelp() {
    echo "bash build.sh package-name [<package-name>]"
}

if [ $# -eq 0 ]; then
    printHelp
    exit 0
fi

rpmBuild() {
    for var in $*
    do
        dlrn --config-file projects.ini --info-repo ../rdoinfo/ --package-name $var
    done
}

cd $DLRN_PATH
su dlrn && rpmBuild
