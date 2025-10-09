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
