//! Test Main.mc
//!
//! Copyright Greg Caufield 2020

using Toybox.Lang;

using MonkeyTest.Tests;

var testSuites = [
];

(:test)
function runAllTests(logger) {
  var testRunner = new Tests.TestRunner();
  return testRunner.runAllTestSuites(logger, testSuites);
}

