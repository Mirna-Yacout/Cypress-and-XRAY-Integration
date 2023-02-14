#!/bin/bash

# command for script persmissions: chmod 755 execute_module.sh
# command to run script: ./execute_module.sh $module $version $testplanid
# shell command example: ./execute_module.sh login 1.0 TD-90

module=$1
version=$2
testplanid=$3

# remove all results from previous module executions
rm -rf ../results/$module
rm -f ../results/*$module*
rm -rf ../cypress/screenshots/*$module*
rm -rf ../cypress/videos/*$module*

# execute the test script for specified module
npm run test_$module

# merge junit xml results script for module
npm run merge-reports_$module

# remove existing files (if any)
rm -f issueFields.json testIssueFields.json

# copy execution templates
cp execution_templates/* ./

# replace place holders in files
sed -i 's/_module_/'"$module"'/g' issueFields.json
sed -i 's/_module_/'"$module"'/g' testIssueFields.json
sed -i 's/_version_/'"$version"'/g' issueFields.json
sed -i 's/_version_/'"$version"'/g' testIssueFields.json
sed -i 's/_testplanid_/'"$testplanid"'/g' issueFields.json
sed -i 's/_testplanid_/'"$testplanid"'/g' testIssueFields.json

./xray_script.sh $module