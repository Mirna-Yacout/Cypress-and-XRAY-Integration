#!/bin/bash

# command for script persmissions: chmod 755 execute_regression.sh
# command to run script: ./execute_regression.sh

version=$1
testplanid=$2

# remove all results from previous executions
rm -rf ../results/*
rm -f ../results/*
rm -f ../cypess/screenshots/*
rm -f ../cypess/videos/*

# execute all test scripts below
./execute_module.sh "login" $version $testplanid

# To add another module/ test script, copy the line below and replace the <module_name> with the module folder name
# ./execute_module.sh "<module_name>" $version $testplanid