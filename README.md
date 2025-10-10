# C# Playwright Template

## Stack

* .NET C#
* Playwright
* NodeJS (For Playwright browsers only)

## Requirements

- [.NET SDK](https://dotnet.microsoft.com/download) (version 8.0 or later)
- [Node.js](https://nodejs.org/) (for Playwright browsers)

## Setup

Clone the repo and run:

```bash
dotnet restore
npx playwright install
```

Install `make`

## Usage

See the `Makefile` for prepackaged commands. 

Some basic command examples include...

Run test:

```bash
dotnet test
```

List tests:

```bash
dotnet test --list-tests
```

Clean build:

```bash
dotnet clean
```

## Test and Coverage Reporting

This project uses NUnit for testing and Coverlet + ReportGenerator for code coverage.

* UnitTests and RegressionTests are kept in separate test projects under `Tests/`.
* Coverage data is collected during test runs in Cobertura XML format.
* All coverage files are stored in the `Reports` folder:
  * `Reports/UnitTests/coverage.cobertura.xml`
  * `Reports/RegressionTests/coverage.cobertura.xml`
* The `make all` command (Windows) runs both test suites, collects coverage, and generates a combined HTML report in:
  * `Reports/CoverageReport/index.html`
* The workflow cleans old reports at the start of each run, ensuring only the latest results are present.

This setup provides a single, unified view of test coverage across all test types while keeping source folders organized.
