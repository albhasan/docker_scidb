#!/bin/bash
#echo "#########################################################"
#echo "Remove array versions"
# remove all of the array versions but the latest
# ./removeArrayVersions.sh ARRAY_NAME
# ./removeArrayVersions.sh MOD09Q1
#echo "#########################################################"

if [ "$#" -ne 1 ]; then
    echo "Illegal number of parameters"
	exit 1
fi
ARRAY_NAME=$1
NVERSION=$(iquery -aq "versions($ARRAY_NAME);" | wc -l)
let NVERSION=$(($NVERSION - 2))
IQUERYCMD="iquery -aq \"remove_versions($ARRAY_NAME, $NVERSION);\""
eval $IQUERYCMD
