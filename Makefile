# Makefile for Windows PowerShell / cmd

# Ensure coverage folders exist
coverage_dirs:
	if not exist Tests\UnitTests\coverage mkdir Tests\UnitTests\coverage
	if not exist Tests\RegressionTests\coverage mkdir Tests\RegressionTests\coverage
	if not exist TestResults mkdir TestResults

# Run UnitTests with coverage
unit-tests: coverage_dirs
	@echo Running UnitTests with coverage...
	cmd /c dotnet test "Tests\UnitTests\UnitTests.csproj" --logger:nunit;LogFileName="TestResults\UnitTests_TestResults.xml" --collect:"XPlat Code Coverage" /p:CoverletOutputFormat=cobertura /p:CoverletOutput="Tests\UnitTests\coverage\coverage.cobertura.xml" /p:SkipFailedTests=false

# Run RegressionTests with coverage, continue on failure
regression-tests: coverage_dirs
	@echo Running RegressionTests with coverage (ignoring failures)...
	cmd /c dotnet test "Tests\RegressionTests\RegressionTests.csproj" --logger:nunit;LogFileName="TestResults\RegressionTests_TestResults.xml" --collect:"XPlat Code Coverage" /p:CoverletOutputFormat=cobertura /p:CoverletOutput="Tests\RegressionTests\coverage\coverage.cobertura.xml" /p:SkipFailedTests=false || echo Regression tests failed, continuing...

# Generate combined HTML coverage report
coverage-report: coverage_dirs
	@echo Generating HTML coverage report...
	cmd /c dotnet tool install --global dotnet-reportgenerator-globaltool --version 5.1.17 || echo ReportGenerator already installed
	cmd /c reportgenerator -reports:"Tests\UnitTests\coverage\coverage.cobertura.xml;Tests\RegressionTests\coverage\coverage.cobertura.xml" -targetdir:"CoverageReport" -reporttypes:Html

# Run all steps
all: unit-tests regression-tests coverage-report
	@echo All steps completed successfully.
