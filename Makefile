# Makefile for Windows PowerShell / cmd

coverage_dirs:
	if not exist Reports mkdir Reports
	if not exist Reports\CoverageReport mkdir Reports\CoverageReport

# Run UnitTests with coverage
unit-tests: coverage_dirs
	@echo === Running UnitTests with coverage ===
	cmd /c dotnet test "Tests\UnitTests\UnitTests.csproj" --collect:"XPlat Code Coverage" /p:SkipFailedTests=false

# Run RegressionTests with coverage
regression-tests: coverage_dirs
	@echo === Running RegressionTests with coverage (ignoring failures) ===
	cmd /c dotnet test "Tests\RegressionTests\RegressionTests.csproj" --collect:"XPlat Code Coverage" /p:SkipFailedTests=false || echo Regression tests failed, continuing...

# Generate combined HTML coverage report
coverage-report: coverage_dirs
	@echo === Generating HTML coverage report ===
	cmd /c dotnet tool install --global dotnet-reportgenerator-globaltool --version 5.1.17 || echo ReportGenerator already installed
	cmd /c reportgenerator -reports:"Tests\UnitTests\coverage\coverage.cobertura.xml;Tests\RegressionTests\coverage\coverage.cobertura.xml" -targetdir:"Reports\CoverageReport" -reporttypes:"Html;TextSummary" -title:"Combined Coverage Report (Unit + Regression)"
	start "" "Reports\CoverageReport\index.html"

# Run everything
all: unit-tests regression-tests coverage-report
	@echo === All steps completed successfully ===
