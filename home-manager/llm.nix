{ config, lib, pkgs, ... }:
let python = pkgs.python311;
    pythonPackages = pkgs.python311Packages;

    # from https://github.com/NixOS/nixpkgs/pull/244564
    pydantic = python.pkgs.buildPythonPackage rec {
      pname = "pydantic";
      version = "2.0.3";
      format = "pyproject";

      src = pkgs.fetchFromGitHub {
        owner = "pydantic";
        repo = "pydantic";
        rev = "v${version}";
        hash = "sha256-Nx6Jmx9UqpvG3gMWOarVG6Luxgmt3ToUbmDbGQTHQto=";
      };

      patches = [
        ./01-remove-benchmark-flags.patch
      ];

      nativeBuildInputs = with pythonPackages; [
        hatch-fancy-pypi-readme
        hatchling
      ];

      propagatedBuildInputs = with pythonPackages; [
        annotated-types
        pydantic-core
        typing-extensions
      ];

      passthru.optional-dependencies = {
        email = with pythonPackages; [
          email-validator
        ];
      };

      pythonImportsCheck = [ "pydantic" ];

      nativeCheckInputs = with pythonPackages; [
        pytestCheckHook
        dirty-equals
        pytest-mock
        pytest-examples
        faker
      ];

      disabledTestPaths = [
        "tests/benchmarks"
      ];

      meta = with lib; {
        description = "Data validation using Python type hints";
        homepage = "https://github.com/pydantic/pydantic";
        changelog = "https://github.com/pydantic/pydantic/blob/v${version}/HISTORY.md";
        license = licenses.mit;
        maintainers = with maintainers; [ wd15 ];
      };
    };

    click-default-group-wheel = python.pkgs.buildPythonPackage rec {
      pname = "click-default-group-wheel";
      version = "1.2.2";
      format = "pyproject";

      src = pkgs.fetchPypi {
        inherit pname version;
        hash = "sha256-6Q2kLZLAPoihLtDAtpyKKa+10249yNKcQjukIZ5td0c=";
      };

      propagatedBuildInputs = with pythonPackages; [
        click
        setuptools
      ];

      meta = {
        homepage = "https://github.com/click-contrib/click-default-group";
        description = "click-default-group packaged as a wheel";
      };
    };

    python-ulid = python.pkgs.buildPythonPackage rec {
      pname = "python-ulid";
      version = "1.1.0";
      format = "pyproject";

      src = pkgs.fetchPypi {
        inherit pname version;
        hash = "sha256-X7XkqR24ypPok4phM2Cz3vKZtg1B+Ecnmow5ybLpxl4=";
      };

      propagatedBuildInputs = with pythonPackages; [
        setuptools
      ];

      meta = {
        homepage = "https://github.com/mdomke/python-ulid";
        description = "Universally Unique Lexicographically Sortable Identifier";
      };
    };
    
    llm = python.pkgs.buildPythonApplication rec {
      pname = "llm";
      version = "0.7";
      format = "setuptools";

      src = pkgs.fetchPypi {
        inherit pname version;
        hash = "sha256-PuZsl6UjVUJvp4ObhUybsf0BPGzuEoY2UNL69M+Px0g=";
      };

      propagatedBuildInputs = with pythonPackages; [
        click
        openai
        click-default-group-wheel
        sqlite-utils
        pydantic
        pyyaml
        pluggy
        python-ulid
        setuptools
      ];

      meta = {
        homepage = "https://llm.datasette.io";
        description = "A CLI utility and Python library for interacting with Large Language Models, including OpenAI, PaLM and local models installed on your own machine.";
      };
    };
in
{
  home.packages = [llm];
}
