
# Cypress and XRAY Integration

This project is implemented using Cypress 10 and mocha reporters to implement, execute and report test scenarios for  a frontend interface. The mocha reporters produce 3 types of results added to the execution status that is found in the terminal. Mocha produces the following results after execution:

- Screenshots of failures during executing specs under cypress/screenshots folder
- Videos of specs execution until failure under cypress/ videos folder
- All specs execution results in a JUnit xml format under /results folder

XRAY API is used to write the execution results to Jira after execution. The whole process was automated for easy use by 3 shell scripts. The scripts usage prcoess is described under the usage section.

The framework is prepared with easy to use shell scripts that utilize the package.json scripts to execute and prepare results that can then be uploaded to Jira using XRAY for test reporting.

## Getting started

### Prerequisites

Project:
- Visual Studio (recommended for easy code usage)
- Node.js and Npm
- Git
- Cypress 10 or above (already installed when cloning project framework from github)
- Mocha and mochawesome reporters (already installed when cloning project framework from github)

Application under test:
- Application base URL to be tested is added in the "cypress.config.js" file (e2e -> baseUrl).

Jira:
- XRAY is installed and license is valid/ renewed on Jira.
- Read/ write access to project on Jira.

### Installation

Since project is already installed and node_modules already exists you only need to clone the Project Repository.

Check the [Cypress Installation Documentation](https://docs.cypress.io/guides/getting-started/installing-cypress), [Cypress Reporters Documentation](https://docs.cypress.io/guides/tooling/reporters) and the [Cypress Migration Guide](https://docs.cypress.io/guides/references/migration-guide#Cypress-Changes) for more information regarding more installation steps.

## Usage

### Create new module Spec

To create a new module spec:

- Create a new Spec file in the intended location for the module following the naming convention: "<module_name_spec_info>_spec.cy.js" under the folder with the module name under e2e e.g.

```
e2e/login/login_spec.cy.js
```

- Create a new script in the "package.json" file, if not already created, as follows:
```
"test_<module_name>": "./node_modules/cypress/bin/cypress run -s cypress/e2e/<module url>/<module_name>/*_spec.cy.js --reporter junit --reporter-options mochaFile=results/<module_name>/test_<module_name>_results-[hash].xml",
```
For example, for the login module we can add the following script:

```
"test_login": "./node_modules/cypress/bin/cypress run -s cypress/e2e/login/*_spec.cy.js --reporter junit --reporter-options mochaFile=results/login/test_login_results-[hash].xml",
```
The [hash] at the end of the results file name is added to prevent overwriting specs results of the same module.

### Execute module locally

To execute a module that was added in the script as described in the previous section locally, type the command "npm run test_<module_name>" in the terminal for example:

```
npm run test_login
```

The execution of the "test_<module_name>" script produces a JUnit formatted xml report in a folder "/results/<module_name>" located in the root project folder. The results files and folder are produced by the mocha reporters with the following naming convention: "/results/test_<module_name>_results.xml". For example the previous script execution will produce the folder/<module_name> folder/file e.g. "results/login/test_login_results.xml"

In case of failures, the errors screenshots and the spec execution video are also produced by the mocha reporters as follows: "/cypress/screenshots/<spec_name>+error.png" and "/cypress/videos/<spec_name>.mp4" respectively.

### Execute module via script and upload results automatically to Jira using xray

In order to run tests for a module and upload the results to XRAY/ Jira automatically, a test plan should be manually created in Jira first (This step is to be automated in the future and added to the script).

Make sure that your XRAY client_id and client_secret are added correctly to the "xray_script.sh" file.
You can use the following link to produce your client_id and client_secret keys: from project settings under XRAY settings.

Navigate to the script location "/xray".

Execute the "execute_module.sh" shell script.

The script needs three input values: <module_name> <execution_version> <Jira_testplan_id>.

For example, to execute the login module spec and upload the results to the test plan with id TD-90 while adding the execution version input as 2.0.0 in the test execution, we should use the script as follows:

```
./execute_module.sh login 2.0.0 TD-90
```

Note: If the script had permission problems, try executing the following command:

```
chmod 755 <script_name>.sh
```

In the example above, the script will do the following:

- Execute the login module spec "test_login" locally and produce the "test_login_results-[hash].xml" file as well as the failures screenshots and video, if errors were produced.
- Merge the login module results into 1 xml file in "/results" folder directly with the name: "test_login_results.xml" using the script "merge-reports_login".
- Remove the old files "issueFields.json" and "testIssueFields.json" from the "xray" folder, if found.
- Copy new file templates with the names "issueFields.json" and "testIssueFields.json" from the template folder named "execution_templates" into the "xray" folder.
- Replace the following place holders with the values provided to the command:

```
_module_ is replaced by <module_name>
_version_ is replaced by <execution_version>
_testplanid_ is replaced by <Jira_testplan_id>
```
- Lastly, it executes the "xray_script.sh" shell script which sends two API requests to XRAY in order to authenticate and upload the JUnit xml results respectively. The results uploaded to Jira using the API request does as follows:

- A new execution run is created with the attributes added that is linked to the test plan provided.
- If tests were found with the same test definition on Jira, then their final results are uploaded to the execution.
- If a test was not found with the same test definition on Jira, then first the test is created on Jira then the result is uploaded to its execution run.

Described below is the "xray_script.sh" shell script used to authenticate and upload results to XRAY/ Jira:
  - A personalized "client_id" and "client_secret" keys are used to send a curl request for authentication using the url: "https://xray.cloud.getxray.app/api/v2/authenticate".
  - The previously prepared files, "test_<module_name>_results.xml", "issueFields.json" and "testIssueFields.json", are uploaded as payload data when sending the API request: "https://xray.cloud.getxray.app/api/v2/import/execution/junit/multipart".
Check the XRAY documentation for more information about the API requests in the documentation section.

### Upload results manually to Jira using xray

In case of a local execution that needs to be manually uploaded to Jira using xray, the script steps can be done manually using the following steps:

- Make sure the module/ spec(s) are executed and the results files for the module are created successfully in the "/results/<module_name>" folder with the correct name following the format "test_<module_name>_results-[hash].xml".
- Merge the module's xml results into 1 xml result file in the "results/" folder with the name "test_<module_name>_results.xml" by executing the script "merge-reports_<module_name>". For example to merge login module results execute the script "merge-reports_login" as follows:

```
npm run merge-reports_login
```

- Remove any old files with name "issueFields.json" or "testIssueFields.json" from the "xray" folder, if found.
- Copy new template files with the names "issueFields.json" and "testIssueFields.json" from the template folder named "execution_templates" into the "xray" folder.
NOTE: PLEASE DO NOT MESS WITH THE TEMPLATES INSIDE THE TEMPLATE FOLDER TO PREVENT PROBLEMS WITH THE SCRIPT EXECUTION.
- Replace the following place holders with the values you need to appear in the Test Plan as shown below:

```
_module_ is replaced by <module_name>
_version_ is replaced by <execution_version>
_testplanid_ is replaced by <Jira_testplan_id>
```
- Make sure the your client_id and client_secret are added correctly to the "xray_script.sh" file.
- Navigate to the script location "/xray".
- Execute the "xray_script.sh" which needs the <module_name> as an input as shown in the example below:

```
./xray_script.sh login
```
The script will send two API requests to XRAY in order to authenticate and upload the JUnit xml results respectively to the test plan you request.

### Execute all tests in all specs in the same execution

In order to execute all tests in all specs at the same time, follow exactly the same process in the previous sections while replacing the <module_name> with the string "all_tests" as follows:

- With the script
```
./execute_module.sh all_tests 2.0.0 TD-90
```
- Without the script
```
npm run test_all_tests
```
Note: This will execute all tests in the same execution uploaded to Jira, not separated for each module.

### Execute all tests in separate module executions (REGRESSION)

For better results reporting, the script "execute_regression.sh" executes and uploads each module separately so that results are recorded for each module in a separate execution under the same test plan id.

Navigate to the script location "/xray".

Execute the script and provide the version and test plan id as follows:

```
./execute_regression.sh 2.0.0 TD-97
```
The scripts calls the "./execute_module.sh" script for each module separately which allows the separation of results in the end.

To add another module/ test script, copy the line below and replace the <module_name> with the module folder name in the "execute_regression.sh" script:
```
./execute_module.sh "<module_name>" $version $testplanid
```

### Issues and future work suggestions

- Automate Test Plan Creation in Script
- Replace hash in results files names with timestamp

## Documentation

[Cypress Installation](https://docs.cypress.io/guides/getting-started/installing-cypress)

[Cypress Reporters](https://docs.cypress.io/guides/tooling/reporters)

[Cypress Migration Guide](https://docs.cypress.io/guides/references/migration-guide#Cypress-Changes)

[XRAY - Importing JUnit xml reports](https://docs.getxray.app/display/XRAY/Taking+advantage+of+JUnit+XML+reports)

[XRAY - Testing using Cypress in Javascript](https://docs.getxray.app/display/XRAY/Testing+using+Cypress+in+JavaScript)

[XRAY - API Requests v2.0](https://docs.getxray.app/display/XRAY/v2.0)
