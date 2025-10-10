# Makefile for Windows PowerShell / cmd

coverage_dirs:
	if not exist Reports mkdir Reports
	if not exist Reports\UnitTests mkdir Reports\UnitTests
	if not exist Reports\RegressionTests mkdir Reports\RegressionTests

# Run UnitTests with coverage
unit-tests: coverage_dirs
	@echo Running UnitTests with coverage...
	cmd /c dotnet test "Tests\UnitTests\UnitTests.csproj" --collect:"XPlat Code Coverage" /p:SkipFailedTests=false
	@echo Copying UnitTests coverage XML to Reports...
	for /D %%d in ("Tests\UnitTests\TestResults\*") do if exist "%%d\coverage.cobertura.xml" copy /Y "%%d\coverage.cobertura.xml" "Reports\UnitTests\coverage.cobertura.xml"

# Run RegressionTests with coverage
regression-tests: coverage_dirs
	@echo Running RegressionTests with coverage (ignoring failures)...
	cmd /c dotnet test "Tests\RegressionTests\RegressionTests.csproj" --collect:"XPlat Code Coverage" /p:SkipFailedTests=false || echo Regression tests failed, continuing...
	@echo Copying RegressionTests coverage XML to Reports...
	for /D %%d in ("Tests\RegressionTests\TestResults\*") do if exist "%%d\coverage.cobertura.xml" copy /Y "%%d\coverage.cobertura.xml" "Reports\RegressionTests\coverage.cobertura.xml"

# Generate combined HTML coverage report
coverage-report: coverage_dirs
	@echo Generating HTML coverage report...
	cmd /c dotnet tool install --global dotnet-reportgenerator-globaltool --version 5.4.17 || echo ReportGenerator already installed
	cmd /c reportgenerator -reports:"Reports\UnitTests\coverage.cobertura.xml;Reports\RegressionTests\coverage.cobertura.xml" -targetdir:"Reports\CoverageReport" -reporttypes:HtmlInline
	start "" "Reports\CoverageReport\index.html"

# Run everything
all: unit-tests regression-tests coverage-report
	@echo All steps completed successfully.
