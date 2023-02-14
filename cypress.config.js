const { defineConfig } = require("cypress");

module.exports = defineConfig({
  reporter: 'junit',
  reporterOptions: {
    mochaFile: 'results/test-results-[hash].xml',
    testCaseSwitchClassnameAndName: true
  },
  e2e: {
    baseUrl: "add URL of application under test here",
    setupNodeEvents(on, config) {
      // implement node event listeners here
      
    },
  },
});
