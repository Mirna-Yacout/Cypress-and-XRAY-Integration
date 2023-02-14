#!/bin/bash

# command for script persmissions: chmod 755 xray_script.sh
# command to run script: ./xray_script.sh $module

module=$1

### import junit xml results into jira-xray ###

client_id='add XRAY client id here'
client_secret='add XRAY client secret here'

# xray authentication request
token=$(curl -H "Content-Type: application/json" -X POST --data '{ "client_id": "'"$client_id"'","client_secret": "'"$client_secret"'" }' https://xray.cloud.getxray.app/api/v2/authenticate| tr -d '"')

# Create new execution and new test case if test case does not exist
curl -H "Content-Type: multipart/form-data" -X POST -F info=@issueFields.json -F results=@../results/test_"$module"_results.xml -F testInfo=@testIssueFields.json -H "Authorization: Bearer $token" https://xray.cloud.getxray.app/api/v2/import/execution/junit/multipart

# Other API requests examples
# curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $token"  --data @"results/test-results.xml" https://xray.cloud.getxray.app/api/v2/import/execution/junit?projectKey=TD
# curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $token"  --data @"results/test-results.xml" https://xray.cloud.getxray.app/api/v2/import/execution/junit?projectKey=TD&testExecKey=TD-4
# curl -H "Content-Type: text/xml" -X POST -H "Authorization: Bearer $token"  --data @"data.xml" https://xray.cloud.getxray.app/api/v2/import/execution/junit?projectKey=XTP&testPlanKey=XTP-12&revision=v2.1.0