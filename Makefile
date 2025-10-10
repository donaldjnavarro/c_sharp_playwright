# --- CLEANUP ---
clean:
	@echo === Cleaning up old coverage reports ===
	:: Remove old coverage files but keep Reports folder and its README.md
	if exist Reports\UnitTests rmdir /s /q Reports\UnitTests
	if exist Reports\RegressionTests rmdir /s /q Reports\RegressionTests
	if exist Reports\CoverageReport rmdir /s /q Reports\CoverageReport
	for /D %%d in (Tests\UnitTests\TestResults Tests\RegressionTests\TestResults) do @(if exist "%%d" rmdir /s /q "%%d")
	@echo === Cleanup complete ===

# --- DIRECTORIES ---
coverage_dirs: clean
	if not exist Reports mkdir Reports
	if not exist Reports\CoverageReport mkdir Reports\CoverageReport
	if not exist Reports\UnitTests mkdir Reports\UnitTests
	if not exist Reports\RegressionTests mkdir Reports\RegressionTests

# --- UNIT TESTS ---
unit-tests: coverage_dirs
	@echo === Running UnitTests with coverage ===
	cmd /c dotnet test "Tests\UnitTests\UnitTests.csproj" --collect:"XPlat Code Coverage" /p:SkipFailedTests=false

# --- REGRESSION TESTS ---
regression-tests: coverage_dirs
	@echo === Running RegressionTests with coverage (ignore failures) ===
	cmd /c dotnet test "Tests\RegressionTests\RegressionTests.csproj" --collect:"XPlat Code Coverage" /p:SkipFailedTests=false || echo Regression tests failed, continuing...

# --- COPY COVERAGE XMLS ---
collect-coverage:
	@echo === Collecting coverage XMLs ===
	for /D %%d in (Tests\UnitTests\TestResults\*) do if exist "%%d\coverage.cobertura.xml" copy /Y "%%d\coverage.cobertura.xml" "Reports\UnitTests\coverage.cobertura.xml"
	for /D %%d in (Tests\RegressionTests\TestResults\*) do if exist "%%d\coverage.cobertura.xml" copy /Y "%%d\coverage.cobertura.xml" "Reports\RegressionTests\coverage.cobertura.xml"

# --- GENERATE COMBINED HTML REPORT ---
coverage-report: coverage_dirs collect-coverage
	@echo === Generating combined HTML coverage report ===
	cmd /c dotnet tool install --global dotnet-reportgenerator-globaltool --version 5.1.17 || echo ReportGenerator already installed
	cmd /c reportgenerator -reports:"Reports\UnitTests\coverage.cobertura.xml;Reports\RegressionTests\coverage.cobertura.xml" -targetdir:"Reports\CoverageReport" -reporttypes:"Html;TextSummary" -title:"Combined Coverage Report (Unit + Regression)" -historydir:"Reports\CoverageReport\history"
	start "" "Reports\CoverageReport\index.html"

# --- FULL WORKFLOW ---
all: unit-tests regression-tests coverage-report
	@echo === All steps completed successfully ===
